import 'package:flutter/material.dart';
import 'package:local_notifications/features/notifications_screen_details.dart';
import 'package:local_notifications/helpers/local_notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  void listenToNotifications() {
    LocalNotificationService.streamController.stream.listen((event) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return NotificationsScreenDetails(notificationResponse: event);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Basic Notification'),
            trailing: IconButton(
                onPressed: () async {
                  await LocalNotificationService.cancelNotification(id: 0);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )),
            onTap: () async {
              await LocalNotificationService.showBasicNotification();
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Repeated Notification'),
            trailing: IconButton(
                onPressed: () async {
                  await LocalNotificationService.cancelNotification(id: 1);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )),
            onTap: () async {
              await LocalNotificationService.showRepeatedNotification();
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Scheduled Notification'),
            trailing: IconButton(
                onPressed: () async {
                  await LocalNotificationService.cancelNotification(id: 1);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )),
            onTap: () async {
              await LocalNotificationService.showScheduledNotification();
            },
          ),
        ],
      ),
    );
  }
}
