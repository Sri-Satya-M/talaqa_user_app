import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  FirebaseMessaging? _firebaseMessaging;

  get firebaseMessaging => _firebaseMessaging;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void initialize() async {
    FirebaseMessaging.instance.requestPermission();
    initializationSettingsAndroid =
        const AndroidInitializationSettings('notification_icon');
    initializationSettingsIOS = const DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
  }

  Future<void> setupNotifications({
    required BuildContext context,
    required Function(RemoteMessage? message) handleMessage,
  }) async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        if (context.mounted) {
          handleMessage.call(initialMessage);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          // print(message.notification?.body);
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
            'Talaqa',
            'General',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public,
            styleInformation: BigTextStyleInformation(''),
          );
          DarwinNotificationDetails iOSChannelSpecifics =
              const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

          NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSChannelSpecifics,
          );

          await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            message.notification?.body,
            platformChannelSpecifics,
            payload: jsonEncode(message.data),
          );
        }
      },
    );
  }
}
