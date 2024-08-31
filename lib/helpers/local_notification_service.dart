import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// handle notification response
  static receiveNotificationResponse(
      NotificationResponse notificationResponse) {
    log("ReceiveNotificationResponse: $notificationResponse");
  }

  /// Initialize the notification service
  static Future<void> initialize() async {
    // request permission
    requestPermission();
    // initialize local notification
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: receiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            receiveNotificationResponse);
    log('Initializing Local Notification');
  }

  /// request permission
  static Future<void> requestPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    log("Request Permission");
  }

  /// Show Basic notification
  static Future<void> showBasicNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1',
        'Basic channel',
        importance: Importance
            .max, // to display the notification prominently with a full-screen intent
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "Basic Notification",
      "Body",
      notificationDetails,
    );
    log("Basic Notification Showed");
  }

  /// Show Repeated notification
  static Future<void> showRepeatedNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_2',
        'Repeated channel',
        importance: Importance
            .max, // to display the notification prominently with a full-screen intent
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      "Repeated Notification",
      "Body",
      RepeatInterval.everyMinute,
      notificationDetails,
    );
    log("Repeated Notification Showed");
  }

  /// Cancel/remove the notification with the specified id.
  static Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    log("Cancel Notification with id: $id");
  }
}
