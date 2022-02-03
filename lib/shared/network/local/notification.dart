import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static var notifications;
  static String? selectedNotificationPayload;

  static late AndroidInitializationSettings initializationSettingsAndroid;
  static late InitializationSettings initializationSettings;

  static Future init() async {
    notifications = FlutterLocalNotificationsPlugin();
    // initializationSettingsAndroid = AndroidInitializationSettings("flutter");
    // initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    // );
    tz.initializeTimeZones();
  }

  static Future _notificationDetails(channelId) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        //NOTE each task has channel  so channel id is the task id
        '$channelId',
        '$channelId Notifications',
        channelDescription: '$channelId Description',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  static Future shownotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notifications.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
    });
    notifications.show(
        id, title, body, await _notificationDetails("channel Id"),
        payload: payload);
  }

  static Future scheduleNotification(
      DateTime scheduleDate, taskChannelId, String title, String time) async {
    notifications = FlutterLocalNotificationsPlugin();
    await notifications.zonedSchedule(
        taskChannelId,
        title,
        "You have a Task ToDo At " + time,
        await tz.TZDateTime.from(scheduleDate, tz.local),
        await _notificationDetails(taskChannelId),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
