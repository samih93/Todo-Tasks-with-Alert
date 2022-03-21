import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_tasks_with_alert/shared/componets/constants.dart';
import 'package:todo_tasks_with_alert/shared/network/remote/diohelper.dart';

class NotificationApi {
  static var notifications;
  static String? selectedNotificationPayload;

  static late AndroidInitializationSettings initializationSettingsAndroid;
  static late InitializationSettings initializationSettings;

//NOTE initialize notification
  static Future init() async {
    notifications = FlutterLocalNotificationsPlugin();
    initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    initializationSettings = InitializationSettings(
      android: NotificationApi.initializationSettingsAndroid,
    );

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
    notifications.show(
        id, title, body, await _notificationDetails("channel Id"),
        payload: payload);
  }

  static Future scheduleNotification(
      DateTime scheduleDate, taskChannelId, String title, String time) async {
    notifications = FlutterLocalNotificationsPlugin();
    await notifications.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        // debugPrint('notification payload: $payload');
        // selectedNotificationPayload = taskChannelId.toString().trim();
        // print('payload :' + selectedNotificationPayload.toString());
        // //NOTE when click on notification i cancel it cz it remind every day same time
        // // to delete scheduled notification for this event
        // await NotificationApi.notifications
        //     .cancel(int.parse(selectedNotificationPayload.toString()));
      }
      //
    });
    await notifications.zonedSchedule(
        taskChannelId,
        title,
        "You have a Event At  " + time,
        await tz.TZDateTime.from(scheduleDate, tz.local),
        await _notificationDetails(taskChannelId),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // // NOTE push notification when a friend like my post a new post
  // static void createNotification(
  //     String title, DateTime scheduleDate, String time) {
  //   DioHelper.postData(url: 'https://fcm.googleapis.com/fcm/send', data: {
  //     "to": "$devicetoken",
  //     "notification": {
  //       "body": "see details",
  //       "title": " Like Your post",
  //       "sound": "default"
  //     },
  //     "android": {
  //       "priortiy": "HIGH",
  //       "notification": {
  //         "notification_priority": "PRIORITY_MAX",
  //         "sound": "default",
  //         "default_vibrate_timings": true,
  //         "default_light_settings": true
  //       }
  //     },
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "87",
  //       "type": "order"
  //     }
  //   }).then((value) {
  //     print("notification pushed");
  //   }).catchError((error) {
  //     print(error.toString());
  //   });
  // }
}
