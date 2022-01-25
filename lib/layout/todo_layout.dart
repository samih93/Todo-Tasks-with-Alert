import 'dart:ffi';

import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/model/task.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_tasks_with_alert/shared/styles/styles.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

class TodoLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var remindcontroller = TextEditingController();
  List<int> remindList = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todocontroller) => Scaffold(
        key: _scaffoldkey,
        // NOTE App Bar
        appBar: _appbar(todocontroller, context),

        //NOTE Body
        body: Obx(
          () => todocontroller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(
                            DateTime.parse(todocontroller.currentSelectedDate)),
                        style: subHeaderStyle,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        todocontroller.currentSelectedDate !=
                                DateTime.now().toString().split(' ').first
                            ? DateFormat.E().format(DateTime.parse(
                                todocontroller.currentSelectedDate))
                            : "Today",
                        style: headerStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //NOTE timeline datepicker -------------
                      Container(
                        child: DatePicker(
                          DateTime.now(),
                          height: 100,
                          width: 80,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Get.isDarkMode
                              ? Colors.black54
                              : defaultLightColor,
                          selectedTextColor: Colors.white,
                          dayTextStyle: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          dateTextStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          monthTextStyle: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          onDateChange: (value) {
                            var selecteddate = value.toString().split(' ');
                            print(selecteddate[0]);
                            todocontroller.onchangeselectedate(selecteddate[0]);
                          },
                        ),
                      ),
                      // NOTE list Of Tasks
                      Expanded(
                          child: todocontroller
                              .screens[todocontroller.currentIndex]),
                    ],
                  ),
                ),
        ),

        //NOTE bottom navigation
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: todocontroller.currentIndex,
          onTap: (index) {
            todocontroller.onchangeIndex(index);
          },
          items: todocontroller.bottomItems,
        ),
        floatingActionButton: FloatingActionButton(
          child: todocontroller.favIcon,
          onPressed: () {
            if (todocontroller.isOpenBottomSheet.value) {
              if (_formkey.currentState!.validate()) {
                todocontroller
                    .insertTaskByModel(
                        model: new Task(
                            title: titlecontroller.text,
                            date: datecontroller.text,
                            time: timecontroller.text,
                            status: "new",
                            remind: int.parse(
                                todocontroller.selectedRemindItem.value)))
                    // .insertTask(
                    //     title: titlecontroller.text,
                    //     date: datecontroller.text,
                    //     time: timecontroller.text)
                    .then((value) {
                  titlecontroller.text = "";
                  datecontroller.text = "";
                  timecontroller.text = "";
                  Navigator.pop(context);
                  todocontroller.isOpenBottomSheet.value = false;
                  todocontroller.onchangefavIcon(Icon(Icons.edit));
                });
              }
            } else {
              _showBottomSheet(todocontroller);
            }
          },
        ),
      ),
    );
  }

  _showBottomSheet(TodoLayoutController todocontroller) {
    _scaffoldkey.currentState!
        .showBottomSheet(
          (context) => Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultTextFormField(
                        controller: titlecontroller,
                        inputtype: TextInputType.text,
                        prefixIcon: Icon(Icons.title),
                        ontap: () {},
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "title must not be empty";
                          }
                        },
                        text: "Task Name"),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        readonly: true,
                        controller: datecontroller,
                        inputtype: TextInputType.datetime,
                        prefixIcon: Icon(Icons.date_range),
                        ontap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.parse('2010-01-01'),
                                  lastDate: DateTime.parse('2030-01-01'))
                              .then((value) {
                            //Todo: handle date to string
                            //print(DateFormat.yMMMd().format(value!));
                            var tdate = value.toString().split(' ');
                            datecontroller.text = tdate[0];
                          });
                        },
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "date must not be empty";
                          }
                        },
                        text: "date"),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        readonly: true,
                        controller: timecontroller,
                        inputtype: TextInputType.number,
                        prefixIcon: Icon(Icons.watch_later_outlined),
                        ontap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) => timecontroller.text =
                                  value!.format(context).toString());
                        },
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "time must not be empty";
                          }
                        },
                        text: "time"),
                    SizedBox(
                      height: 10,
                    ),
                    //NOTE Remind
                    Obx(
                      () => defaultTextFormField(
                        readonly: true,
                        hinttext:
                            "${todocontroller.selectedRemindItem.value} minutes early",
                        controller: remindcontroller,
                        inputtype: TextInputType.name,
                        suffixIcon: DropdownButton(
                          underline: Container(
                            height: 0,
                          ),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                          iconSize: 25,
                          elevation: 4,
                          items: remindList
                              .map<DropdownMenuItem<String>>((int value) {
                            return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()));
                          }).toList(),
                          onChanged: (value) {
                            todocontroller.onchangeremindlist(value);
                            print(todocontroller.selectedRemindItem.value);
                          },
                          //! to display number beside the arrow
                          // value: todocontroller.selectedRemindItem.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          elevation: 30,
        )
        .closed
        .then((value) {
      // Navigator.pop(context); no need cs i close it by hand
      todocontroller.isOpenBottomSheet.value = false;
      todocontroller.onchangefavIcon(Icon(Icons.edit));
    });

    todocontroller.isOpenBottomSheet.value = true;
    todocontroller.onchangefavIcon(Icon(Icons.add));
  }

  _appbar(TodoLayoutController todocontroller, BuildContext context) => AppBar(
        title: Text(
          todocontroller.appbar_title[todocontroller.currentIndex],
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
            onPressed: () {
              todocontroller.isOpenBottomSheet.value == false
                  ? todocontroller.onchangeThem()
                  : null;
              //
            },
            icon: Icon(
              Get.isDarkMode ? Icons.wb_sunny : Icons.mode_night,
              size: 30,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      );
}
