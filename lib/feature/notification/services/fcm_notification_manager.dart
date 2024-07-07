import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';

class FcmNotificationManager {
  FcmNotificationManager._internal();
  factory FcmNotificationManager(BuildContext cntxt) {
    _notificationService.context = cntxt;
    return _notificationService;
  }
  BuildContext? context;
  RemoteMessage? message;
  static final FcmNotificationManager _notificationService =
      FcmNotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize Firebase Messaging
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    await _setupFlutterNotifications();
    await setupToken();
    // Handle the received notifications
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Get the initial message if the app is opened from a terminated state
    var initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<void> setupToken() async {
    try {
      // Get the token each time the application loads
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM device token $token');
      // Save the initial token to the database
      await saveTokenToOurDatabase(token!);

      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToOurDatabase);
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.message}');
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.message}');
    } on SocketException catch (e) {
      debugPrint('SocketException: ${e.message}');
    } on TimeoutException catch (e) {
      debugPrint('TimeoutException: ${e.message}');
    } catch (e) {
      debugPrint('An unknown error occurred: $e');
    }
  }

  Future<void> saveTokenToOurDatabase(String token) async {
    GetIt.I<NotificationServices>().storeFcmTokenIntoServer(fcmToken: token);
  }

  Future<void> _setupFlutterNotifications() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings());

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onSelectNotificationBackground,
      onDidReceiveNotificationResponse: (details) async {
        debugPrint('Notification Details : ${details.payload}');
        if (Platform.isAndroid) {
          _handleMessage(message);
        }
      },
    );
  }

  void _onMessageReceived(RemoteMessage _message) {
    var notification = _message.notification;
    message = _message;
    if (kDebugMode) {
      print('Notification title: ${notification?.title}');
      print('Notification Body: ${notification?.body}');
      print('Notification Body: ${_message.data}');
      print('Notification Body: ${_message.data['id']}');
      print('Notification Body: ${_message.data['pageName']}');
    }
    showNotification(notification);
  }

  void showNotification(RemoteNotification? notification) {
    final androidNotificationChannel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max,
        playSound: true);
    const darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final androidNotificationdetails = AndroidNotificationDetails(
        androidNotificationChannel.id, androidNotificationChannel.name,
        channelDescription: 'your channel description',
        icon: notification?.android?.smallIcon,
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
        ticker: 'ticker');
    final notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
      android: androidNotificationdetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title.toString(),
          notification?.body.toString(),
          notificationDetails);
    });
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message);
  }

  Future<void> _handleMessage(RemoteMessage? msg) async {
    // Handle the message when the app is opened from a notification
    // You can navigate to a specific screen here
    if (msg?.data['pageName'] != null) {
      if (isBottomNavScreen(msg?.data['pageName'] as String)) {
        context?.goNamed(msg?.data['pageName'].toString() ?? '/home');
      } else {
        context?.pushNamed(msg?.data['pageName'].toString() ?? '/home');
      }
    }
  }

  @pragma('vm:entry-point')
  static void _onSelectNotificationBackground(
      NotificationResponse notificationResponse) {
    debugPrint('Notification (${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with '
        'Payload ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print, lines_longer_than_80_chars
      print(
          'Notification action tapped with input : ${notificationResponse.input}');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  bool isBottomNavScreen(String pageName) {
    switch (pageName) {
      case '/home':
      case '/service':
      case '/bookings':
      case '/family':
        return true;
      default:
        return false;
    }
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage remoteMessage) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  debugPrint('${remoteMessage.notification?.title}');
  debugPrint('${remoteMessage.notification?.bodyLocArgs}');
}