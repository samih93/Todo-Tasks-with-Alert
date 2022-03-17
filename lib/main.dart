import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layout.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/network/local/cashhelper.dart';
import 'package:todo_tasks_with_alert/shared/network/local/notification.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // NOTE : catch notification  with parameter while app is closed and when on press notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("message data opened " + message.data.toString());
    //showToast(message: "on message opened", status: ToastStatus.Success);
  });

  await CashHelper.init();

// NOTE Notification
  await NotificationApi.init();

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
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!),
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkThem,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TodoLayout(),
    );
  }
}
