import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_tasks_with_alert/model/task.dart';
import 'package:todo_tasks_with_alert/modules/archive_tasks/archive_task.dart';
import 'package:todo_tasks_with_alert/modules/done_tasks/done_task.dart';
import 'package:todo_tasks_with_alert/modules/new_tasks/new_task_screen.dart';
import 'package:todo_tasks_with_alert/shared/componets/constants.dart';
import 'package:todo_tasks_with_alert/shared/network/local/TodoDbHelper.dart';
import 'package:todo_tasks_with_alert/shared/network/local/cashhelper.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';
import 'package:uuid/uuid.dart';

class TodoLayoutController extends GetxController {
  List<Map> _newtaskMap = [];
  List<Map> get newtaskMap => _newtaskMap;
  List<Map> _donetaskMap = [];
  List<Map> get donetaskMap => _donetaskMap;
  List<Map> _archivetaskMap = [];
  List<Map> get archivetaskMap => _archivetaskMap;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String currentSelectedDate = DateTime.now().toString().split(' ').first;

  final screens = [NewTaskScreen(), DoneTaskScreen(), ArchiveTaskScreen()];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Task"),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline), label: "Done"),
    BottomNavigationBarItem(
      icon: Icon(Icons.archive_outlined),
      label: "Archive",
    ),
  ];

  final appbar_title = ["New Tasks", "Done Tasks", "Archive Tasks"];

  TodoDbHelper dbHelper = TodoDbHelper.db;

  var isloading = true.obs;

  @override
  void onInit() async {
    await dbHelper.createDatabase();
    await getDatabasesPath().then((value) => print(value + "/todo.db"));
    await getalltasks();
    print(_newtaskMap.length);
    super.onInit();
  }

// Future<List<Map>> insertTaskToDatabase(
//       {required String title,
//       required String date,
//       required String time}) async {
//     database.transaction((txn) => txn
//             .rawInsert(
//                 'insert into $taskTable(title,date,time,status) values("$title","$date","$time","new")')
//             .then((value) async {
//           print('inserted successfully');
//         }).catchError((error) {
//           print(error.toString());
//         }));

//     return await GetDataFromDatabase();
//   }

// NOTE on select date in time line
  void onchangeselectedate(selecteddate) {
    currentSelectedDate = selecteddate;
    update();
    getalltasks();
  }

//NOTE on change remind list
  var selectedRemindItem = "5".obs;
  onchangeremindlist(value) {
    selectedRemindItem.value = value;
  }

  Future<void> getalltasks() async {
    print(isloading.value);
    _newtaskMap = [];
    _donetaskMap = [];
    _archivetaskMap = [];
    isloading.value = true;
    await dbHelper.database
        .rawQuery("select * from tasks where date='${currentSelectedDate}'")
        .then((value) {
      value.forEach((element) {
        if (element['status'] == "new")
          _newtaskMap.add(element);
        else if (element['status'] == "done")
          _donetaskMap.add(element);
        else if (element['status'] == "archive") _archivetaskMap.add(element);
      });
      _newtaskMap.length > 1
          ? _newtaskMap.sort((a, b) {
              return DateTime.parse(
                      a['date'].toString() + " " + a['time'].toString())
                  .compareTo(DateTime.parse(
                      b['date'].toString() + " " + b['time'].toString()));
            })
          : [];
      // print("N  " + _newtaskMap.length.toString());
      // print("D  " + _donetaskMap.length.toString());
      // print("A  " + _archivetaskMap.length.toString());
    }).then((value) {
      isloading.value = false;
      print(isloading.value);
      update();
    });
  }

//NOTE on change index of bottom navigation
  void onchangeIndex(int index) {
    _currentIndex = index;
    update();
  }

//  add task by model
  insertTaskByModel({required Task model}) async {
    var dbclient = await dbHelper.database;
    var uuid = Uuid();
    model.id = uuid.v1();
    print(model.toJson());
    await dbclient.insert(taskTable, model.toJson());
    getalltasks();
  }

  updatestatusTask({required String taskId, required String status}) async {
    var dbclient = await dbHelper.database;
    await dbclient.rawUpdate(
        "UPDATE  $taskTable SET status= '$status' where  id='$taskId'");
    print("Updated");
    getalltasks();
  }

  deleteTask({required String taskId}) async {
    var dbclient = await dbHelper.database;
    await dbclient.rawDelete("DELETE FROM  $taskTable where  id='$taskId'");
    print("deleted");
    getalltasks();
  }

//NOTE For multi them -------------------------
  var isDarkMode = false.obs;

  void onchangeThem() {
    // isDarkMode.value = !isDarkMode.value;
    // CashHelper.setTheme(key: "isdark", value: isDarkMode.value).then((value) {
    //   print("Theme is ${isDarkMode == true ? "black" : "white"}");
    // });
    // update();
    //! using Get
    if (Get.isDarkMode) {
      Get.changeTheme(Themes.lightTheme);
      print("light");
      CashHelper.setTheme(key: "isdark", value: false);
    } else {
      Get.changeTheme(Themes.darkThem);
      print("dark");
      CashHelper.setTheme(key: "isdark", value: true);
    }
  }
}
