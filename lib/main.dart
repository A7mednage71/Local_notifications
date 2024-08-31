import 'package:flutter/material.dart';
import 'package:local_notifications/features/notifications_screen.dart';
import 'package:local_notifications/helpers/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationsScreen(),
    );
  }
}
