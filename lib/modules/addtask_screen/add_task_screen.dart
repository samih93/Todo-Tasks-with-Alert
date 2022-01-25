import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/model/task.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';
import 'package:todo_tasks_with_alert/shared/styles/styles.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

class AddTaskScreen extends StatelessWidget {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var remindcontroller = TextEditingController();
  List<int> remindList = [5, 10, 15, 20];

  TodoLayoutController todocontroller = Get.find<TodoLayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildFromAddTask(context),
    );
  }

  _buildFromAddTask(BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headerStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
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
                      SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                          text: 'Create Task',
                          background: defaultLightColor,
                          radius: 15,
                          onpress: () {
                            if (_formkey.currentState!.validate()) {
                              todocontroller
                                  .insertTaskByModel(
                                      model: new Task(
                                          title: titlecontroller.text,
                                          date: datecontroller.text,
                                          time: timecontroller.text,
                                          status: "new",
                                          remind: int.parse(todocontroller
                                              .selectedRemindItem.value)))
                                  // .insertTask(
                                  //     title: titlecontroller.text,
                                  //     date: datecontroller.text,
                                  //     time: timecontroller.text)
                                  .then((value) {
                                titlecontroller.text = "";
                                datecontroller.text = "";
                                timecontroller.text = "";
                                Get.back();
                              });
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
