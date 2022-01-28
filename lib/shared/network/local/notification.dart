import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifcationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  //String? selectedNotificationPayload;

  static final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  static final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
  );

  Future shownotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    // await _notifications.initialize(initializationSettings,
    //     onSelectNotification: (String? payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    //   selectedNotificationPayload = payload;
    // });
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future scheduleNotification(
      DateTime scheduleDate, String title, String time) async {
    tz.initializeTimeZones();
    await _notifications.zonedSchedule(
        0,
        title,
        "You have a Task ToDo At " + time,
        await tz.TZDateTime.from(scheduleDate, tz.local),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
