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

  @override
  void onInit() async {
    super.onInit();
    getallevents().then((value) {});
  }

  Future<void> getallevents() async {
    print(isloading.value);
    _all_event = [];
    isloading.value = true;
    await dbHelper.database.rawQuery("select * from $eventTable").then((value) {
      value.forEach((element) {
        all_event.add(Event.fromJson(element));
      });

      all_event.forEach((element) {
        print(element.toJson());
      });
      isloading.value = false;
      print(isloading.value);
      update();
    });
  }
}
