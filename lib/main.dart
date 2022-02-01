import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layout.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/network/local/cashhelper.dart';
import 'package:todo_tasks_with_alert/shared/network/local/notification.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();

//
  await NotificationApi.init();
  NotificationApi.initializationSettingsAndroid =
      AndroidInitializationSettings("drawable/launcher_icon");
  NotificationApi.initializationSettings = InitializationSettings(
    android: NotificationApi.initializationSettingsAndroid,
  );

  // NOTE check cash theme and set it to Get
  bool? isdarkcashedthem = CashHelper.getThem(key: "isdark");
  print("cash theme " + isdarkcashedthem.toString());
  if (isdarkcashedthem != null) {
    Get.changeTheme(isdarkcashedthem ? Themes.darkThem : Themes.lightTheme);
  }

  Get.put(TodoLayoutController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  TodoLayoutController todoController = Get.find<TodoLayoutController>();

  @override
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //NOTE to use 24 hour format
      // builder: (context, child) => MediaQuery(
      //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //     child: child!),
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkThem,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TodoLayout(),
    );
  }
}
