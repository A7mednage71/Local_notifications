import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// create stream connection
  static StreamController<NotificationResponse> streamController =
      StreamController();

  /// handle notification response
  static receiveNotificationResponse(
      NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
    log("Receive Notification Response");
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
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1',
        'Basic channel',
        importance: Importance
            .max, // to display the notification prominently with a full-screen intent
        priority: Priority.high,
        sound:
            RawResourceAndroidNotificationSound('message.mp3'.split('.').first),
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "Basic Notification",
      "Body",
      notificationDetails,
      payload: "Basic Notification",
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
      payload: "Repeated Notification",
    );
    log("Repeated Notification Showed");
  }

  /// Show scheduled notification
  static Future<void> showScheduledNotification() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_3',
        'Scheduled channel',
        importance: Importance
            .max, // to display the notification prominently with a full-screen intent
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        "Scheduled Notification",
        "Body",
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tz.TZDateTime(tz.local, 2024, 8, 31, 11, 45),
        notificationDetails,
        payload: "Scheduled Notification",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    log("Scheduled Notification Showed");
    log("tz: ${tz.local} : $currentTimeZone ");
  }

  /// Show daily scheduled notification
  static Future<void> showDAilyScheduledNotification() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_4',
        'Daily Scheduled channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    var currentTime = tz.TZDateTime.now(tz.local);
    // var scheduleTime = tz.TZDateTime(tz.local, 2024, 9, 1, 0, 25);
    var scheduleTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      0,
    );
    log("currentTime: $currentTime");
    log("scheduleTime actual : $scheduleTime");

    if (scheduleTime.isBefore(currentTime)) {
      log("isBefore");
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }
    log("scheduleTime after isBefore: $scheduleTime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      "Daily Scheduled Notification",
      "Body",
      scheduleTime,
      notificationDetails,
      payload: "Daily Scheduled Notification",
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    log("Daily Scheduled Notification Showed");
    log("tz: ${tz.local} : $currentTimeZone ");
  }

  /// Cancel/remove the notification with the specified id.
  static Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    log("Cancel Notification with id: $id");
  }

  /// Cancel/remove all the notifications
  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    log("Cancel All Notification");
  }
}
