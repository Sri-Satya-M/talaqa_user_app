import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  // Create an instance of FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void initialize() async {
    // Define Android initialization settings
    initializationSettingsAndroid =
        const AndroidInitializationSettings('notification_icon');

    // Define iOS initialization settings
    initializationSettingsIOS = const DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    // Combine the settings for both Android and iOS
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

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        // Initialize the plugin
        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (value) async {
            print("In app notifications");
            if (context.mounted) {
              handleMessage.call(message);
            }
          },
        );

        if (notification != null) {
          print(message.notification?.body);

          // Define Android-specific notification details
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
            'Talaqa',
            'General',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public,
          );

          // Define iOS-specific notification details
          DarwinNotificationDetails iOSChannelSpecifics =
              const DarwinNotificationDetails(
            presentSound: false,
            presentBadge: false,
            presentAlert: false,
          );

          // Combine the details for both Android and iOS
          NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSChannelSpecifics,
          );

          // Show the notification
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
