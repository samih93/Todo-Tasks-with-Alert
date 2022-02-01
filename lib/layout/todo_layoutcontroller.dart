import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_tasks_with_alert/model/event.dart';
import 'package:todo_tasks_with_alert/modules/archive_events/archive_task.dart';
import 'package:todo_tasks_with_alert/modules/done_events/done_events.dart';
import 'package:todo_tasks_with_alert/modules/my_events/my_event_screen.dart';
import 'package:todo_tasks_with_alert/shared/componets/constants.dart';
import 'package:todo_tasks_with_alert/shared/network/local/TodoDbHelper.dart';
import 'package:todo_tasks_with_alert/shared/network/local/cashhelper.dart';
import 'package:todo_tasks_with_alert/shared/network/local/notification.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';
import 'package:uuid/uuid.dart';

class TodoLayoutController extends GetxController {
  List<Event> _neweventList = [];
  List<Event> get neweventList => _neweventList;
  List<Event> _doneeventList = [];
  List<Event> get doneeventList => _doneeventList;
  List<Event> _archiveeventList = [];
  List<Event> get archiveeventList => _archiveeventList;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String currentSelectedDate = DateTime.now().toString().split(' ').first;

  final screens = [MyEventScreen(), DoneEventScreen(), ArchiveEventScreen()];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Events"),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline), label: "Done"),
    BottomNavigationBarItem(
      icon: Icon(Icons.archive_outlined),
      label: "Archive",
    ),
  ];

  final appbar_title = ["My Events", "Done Events", "Archive Events"];

  TodoDbHelper dbHelper = TodoDbHelper.db;

  var isloading = true.obs;

  @override
  void onInit() async {
    await dbHelper.createDatabase();
    await getDatabasesPath().then((value) => print(value + "/todo.db"));
    await getallevents();
    print(_neweventList.length);
    super.onInit();
  }

// Future<List<Map>> inserteventToDatabase(
//       {required String title,
//       required String date,
//       required String time}) async {
//     database.transaction((txn) => txn
//             .rawInsert(
//                 'insert into $eventTable(title,date,time,status) values("$title","$date","$time","new")')
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
    getallevents();
  }

//NOTE on change remind list
  var selectedRemindItem = "5".obs;
  onchangeremindlist(value) {
    selectedRemindItem.value = value;
  }

  Future<void> getallevents() async {
    print(isloading.value);
    _neweventList = [];
    _doneeventList = [];
    _archiveeventList = [];
    isloading.value = true;
    await dbHelper.database
        .rawQuery(
            "select * from $eventTable where date='${currentSelectedDate}'")
        .then((value) {
      value.forEach((element) {
        if (element['status'] == "new")
          _neweventList.add(Event.fromJson(element));
        else if (element['status'] == "done")
          _doneeventList.add(Event.fromJson(element));
        else if (element['status'] == "archive")
          _archiveeventList.add(Event.fromJson(element));
      });
      _neweventList.length > 1
          //NOTE if does not have any new event
          ? _neweventList.sort((a, b) {
              return DateTime.parse(b.date.toString() + " " + b.time.toString())
                  .compareTo(DateTime.parse(
                      a.date.toString() + " " + a.time.toString()));
            })
          : [];

      // print("N  " + _neweventListMap.length.toString());
      // print("D  " + _doneeventListMap.length.toString());
      // print("A  " + _archiveeventListMap.length.toString());
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

//  add event by model
  Future<int> inserteventByModel({required Event model}) async {
    var dbclient = await dbHelper.database;
    //! if i need random id
    // var uuid = Uuid();
    // model.id = uuid.v1();
    // print(model.toJson());
    int id = await dbclient.insert(eventTable, model.toJson());
    await dbHelper.database
        .rawQuery("select * from $eventTable where id='${id}'")
        .then((value) {
      value.forEach((element) {
        if (DateTime.parse(model.date.toString())
                .compareTo(DateTime.parse(currentSelectedDate.toString())) ==
            0) _neweventList.add(Event.fromJson(element));
        // order by date time
        _neweventList.sort((a, b) {
          return DateTime.parse(a.date.toString() + " " + a.time.toString())
              .compareTo(
                  DateTime.parse(b.date.toString() + " " + b.time.toString()));
        });
        update();
      });
    });
    return id;
  }

  updatestatusevent({required String eventId, required String status}) async {
    var dbclient = await dbHelper.database;
    await dbclient
        .rawUpdate(
            "UPDATE  $eventTable SET status= '$status' where  id='$eventId'")
        .then((value) {
      // NOTE if current index ==0 i have two option done or archive
      if (currentIndex == 0) {
        Event event =
            _neweventList.where((element) => element.id == eventId).first;
        if (!event.isBlank!) _neweventList.remove(event);
        if (status == "done") {
          event.status = "done";
          _doneeventList.add(event);
        } else {
          event.status = "archive";
          _archiveeventList.add(event);
        }
      }
      // NOTE if current index ==1 i have one option archive
      if (currentIndex == 1) {
        Event event =
            _doneeventList.where((element) => element.id == eventId).first;
        // NOTE if exist remove it from _done and add to archive and update her status in archive
        if (!event.isBlank!) _doneeventList.remove(event);
        event.status = "archive";
        _archiveeventList.add(event);
      }

      update();
    }).catchError((error) {
      print(error.toString());
    });

    print("Updated");
    //getalltasks();
  }

  deleteEvent({required String eventId}) async {
    var dbclient = await dbHelper.database;
    await dbclient
        .rawDelete("DELETE FROM  $eventTable where  id='$eventId'")
        .then((value) async {
      //NOTE if i am in new event
      // screen
      if (currentIndex == 0) {
        Event event =
            _neweventList.where((element) => element.id == eventId).first;
        //NOTE check if new event contain eventId
        if (!event.isBlank!) _neweventList.remove(event);
      }

      //NOTE if i am in done event
      // screen
      if (currentIndex == 1) {
        Event event =
            _doneeventList.where((element) => element.id == eventId).first;
        //NOTE check if done event contain eventId
        if (!event.isBlank!) _doneeventList.remove(event);
      }
      //NOTE if i am in Archive event
      // screen
      if (currentIndex == 2) {
        Event event =
            _archiveeventList.where((element) => element.id == eventId).first;
        //NOTE check if done event contain eventId
        if (!event.isBlank!) _archiveeventList.remove(event);
      }
      // to delete scheduled notification for this event
      await NotificationApi.notifications.cancel(int.parse(eventId));
      update();
    }).catchError((error) {
      print(error.toString());
    });
    print("deleted");
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
