// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

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
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';

class FcmNotificationManager {
  factory FcmNotificationManager(BuildContext cntxt) {
    _notificationService.context = cntxt;
    return _notificationService;
  }
  FcmNotificationManager._internal();
  BuildContext? context;
  RemoteMessage? message;
  bool isFcmStored = false;
  static final FcmNotificationManager _notificationService =
      FcmNotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (isFcmStored) {
      return;
    }
    // Initialize Firebase Messaging
    await _firebaseMessaging.requestPermission(
      announcement: true,
    );

    await _setupFlutterNotifications();
    await setupToken();
    isFcmStored = true;
    // Handle the received notifications
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Get the initial message if the app is opened from a terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessage(initialMessage);
    }
  }

  Future<void> setupToken() async {
    try {
      // Get the token each time the application loads
      final token = await FirebaseMessaging.instance.getToken();
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
    await GetIt.I<NotificationServices>()
        .storeFcmTokenIntoServer(fcmToken: token);
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
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onSelectNotificationBackground,
      onDidReceiveNotificationResponse: (details) async {
        debugPrint('Notification Details : ${details.payload}');
        if (Platform.isAndroid) {
          await _handleMessage(message);
        }
      },
    );
  }

  void _onMessageReceived(RemoteMessage _message) {
    final notification = _message.notification;
    message = _message;
    if (_message.data.isNotEmpty) {
      GetIt.I<NotificationStore>().refresh();
      if (_message.data['actionType'] == 'openPage' &&
          _message.data['actionUrl'].contains('/bookingDetailsScreen')
              as bool) {
        GetIt.I<MembersStore>().refresh();
      }
    }
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
    );
    const darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final androidNotificationdetails = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: 'your channel description',
      icon: notification?.android?.smallIcon,
      importance: Importance.high,
      priority: Priority.high,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      ticker: 'ticker',
    );
    final notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
      android: androidNotificationdetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title.toString(),
        notification?.body.toString(),
        notificationDetails,
      );
    });
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message);
  }

  Future<void> _handleMessage(RemoteMessage? msg) async {
    // Handle the message when the app is opened from a notification
    // You can navigate to a specific screen here
    if (msg != null && msg.data.isNotEmpty) {
      if (msg.data['actionType'] == 'openPage' &&
          msg.data['actionUrl'] != null &&
          msg.data['actionUrl'] != '/') {
        if (isBottomNavScreen(msg.data['actionUrl'] as String)) {
          context?.go(msg.data['actionUrl'].toString());
        } else {
          await context?.push(msg.data['actionUrl'].toString());
        }
      }
    }
  }

  @pragma('vm:entry-point')
  static void _onSelectNotificationBackground(
    NotificationResponse notificationResponse,
  ) {
    debugPrint('Notification (${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with '
        'Payload ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
        'Notification action tapped with input : ${notificationResponse.input}',
      );
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
