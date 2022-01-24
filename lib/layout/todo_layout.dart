import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/model/task.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class TodoLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todocontroller) => Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
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
                Icons.brightness_4_outlined,
                size: 30,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: todocontroller.isloading
            ? Center(child: CircularProgressIndicator())
            : todocontroller.screens[todocontroller.currentIndex],
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
                            status: "new"))
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
                                  controller: datecontroller,
                                  inputtype: TextInputType.datetime,
                                  prefixIcon: Icon(Icons.date_range),
                                  ontap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate:
                                                DateTime.parse('2010-01-01'),
                                            lastDate:
                                                DateTime.parse('2030-01-01'))
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
                                  text: "time")
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
          },
        ),
      ),
    );
  }
}
