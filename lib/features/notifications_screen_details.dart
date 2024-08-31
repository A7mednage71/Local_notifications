import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsScreenDetails extends StatelessWidget {
  const NotificationsScreenDetails(
      {super.key, required this.notificationResponse});

  final NotificationResponse notificationResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(notificationResponse.id.toString()),
            Text(notificationResponse.payload.toString()),
          ],
        ),
      ),
    );
  }
}
