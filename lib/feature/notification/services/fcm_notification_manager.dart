import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmNotificationManager {
  factory FcmNotificationManager() {
    return _notificationService;
  }

  FcmNotificationManager._internal();
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
    try{
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
    // When the user is logged in then
    // We have to save token to our database
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
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings());

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onSelectNotificationBackground,
      onDidReceiveNotificationResponse: (details) async {
        debugPrint('Notification Details : $details');
      },
    );
  }

  void _onMessageReceived(RemoteMessage message) {
    var notification = message.notification;
    var android = message.notification?.android;

    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            icon: android.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            fullScreenIntent: true,
            visibility: NotificationVisibility.public
          ),
        ),
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    // Handle the message when the app is opened from a notification
    // You can navigate to a specific screen here
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
}
