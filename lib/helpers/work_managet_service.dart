import 'dart:developer';

import 'package:local_notifications/helpers/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static Future<void> initialize() async {
    await Workmanager().initialize(taskAction, isInDebugMode: true);
    taskRegister();
  }

  static Future<void> taskRegister() async {
    // await Workmanager().registerOneOffTask(
    //   // task run only once
    //   "2",
    //   "show daily notification",
    // );

    await Workmanager().registerPeriodicTask(
        // task run every minute
        "2",
        "show repeated notification",
        frequency: const Duration(minutes: 15));
  }

  static Future<void> taskCancel({required String uniqueName}) async {
    await Workmanager().cancelByUniqueName(uniqueName);
  }
}

@pragma('vm:entry-point')
Future<void> taskAction() async {
  Workmanager().executeTask((taskName, inputData) async {
    log("Task: $taskName");
    await LocalNotificationService.showDAilyScheduledNotification();
    return Future.value(true);
  });
}
