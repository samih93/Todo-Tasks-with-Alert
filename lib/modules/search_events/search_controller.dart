import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_tasks_with_alert/model/event.dart';
import 'package:todo_tasks_with_alert/shared/componets/constants.dart';
import 'package:todo_tasks_with_alert/shared/network/local/TodoDbHelper.dart';

class SearchController extends GetxController {
  List<Event> _all_event = [];
  List<Event> get all_event => _all_event;
  var isloading = true.obs;
  TodoDbHelper dbHelper = TodoDbHelper.db;

  Future<void> getalleventsInDay() async {
    print(isloading.value);
    _all_event = [];
    isloading.value = true;
    await dbHelper.database
        .rawQuery("select * from $eventTable where date=''")
        .then((value) {
      value.forEach((element) {});
      // _neweventList.length > 1
      //     //NOTE if does not have any new event
      //     ? _neweventList.sort((a, b) {
      //         return DateTime.parse(a.date.toString() + " " + a.time.toString())
      //             .compareTo(DateTime.parse(
      //                 b.date.toString() + " " + b.time.toString()));
      //       })
      //     : [];

      // print("N  " + _neweventListMap.length.toString());
      // print("D  " + _doneeventListMap.length.toString());
      // print("A  " + _archiveeventListMap.length.toString());
    }).then((value) {
      isloading.value = false;
      print(isloading.value);
      update();
    });
  }
}
