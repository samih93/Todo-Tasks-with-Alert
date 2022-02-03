import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/model/event.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';
import 'package:todo_tasks_with_alert/shared/network/local/notification.dart';
import 'package:todo_tasks_with_alert/shared/styles/styles.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

class AddEventScreen extends StatelessWidget {
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
                'Add Event',
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
                          ontap: () {},
                          onvalidate: (value) {
                            if (value!.isEmpty) {
                              return "title must not be empty";
                            }
                          },
                          text: "Event Name"),
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
                                .then((value) {
                              timecontroller.text =
                                  value!.format(context).toString();
                              //! 1970-01-01 time selected:00.000
                              // print(DateFormat("hh:mm a")
                              //     .parse(timecontroller.text.toString()));
                            });
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
                      Container(
                        width: double.infinity,
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          value: todocontroller.selectedRemindItem.value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                          items: remindList
                              .map((e) => DropdownMenuItem<String>(
                                    value: e.toString(),
                                    child: Text(e.toString()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            todocontroller.onchangeremindlist(value);
                            print(todocontroller.selectedRemindItem.value);
                          },
                        ),
                      ),
                      // Obx(
                      //   () => defaultTextFormField(
                      //     readonly: true,
                      //     hinttext:
                      //         "${todocontroller.selectedRemindItem.value} minutes early",
                      //     controller: remindcontroller,
                      //     inputtype: TextInputType.name,
                      //     suffixIcon: DropdownButton(
                      //       underline: Container(
                      //         height: 0,
                      //       ),
                      //       icon: Icon(Icons.keyboard_arrow_down,
                      //           color: Colors.grey),
                      //       iconSize: 25,
                      //       elevation: 4,
                      //       items: remindList
                      //           .map<DropdownMenuItem<String>>((int value) {
                      //         return DropdownMenuItem<String>(
                      //             value: value.toString(),
                      //             child: Text(value.toString()));
                      //       }).toList(),
                      //       onChanged: (value) {
                      //         todocontroller.onchangeremindlist(value);
                      //         print(todocontroller.selectedRemindItem.value);
                      //       },
                      //       //! to display number beside the arrow
                      //       // value: todocontroller.selectedRemindItem.value,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                          text: 'Create Event',
                          background: defaultLightColor,
                          radius: 15,
                          onpress: () async {
                            if (_formkey.currentState!.validate()) {
                              //NOTE  am pm to 24 hours
                              DateTime date2 = DateFormat("hh:mm a").parse(
                                  timecontroller.text
                                      .toString()); // think this will work better for you
                              String time =
                                  DateFormat("HH:mm").format(date2).toString();
                              await todocontroller
                                  .inserteventByModel(
                                      model: new Event(
                                          title: titlecontroller.text,
                                          date: datecontroller.text,
                                          time: time,
                                          status: "new",
                                          remind: int.parse(todocontroller
                                              .selectedRemindItem.value)))
                                  // .insertTask(
                                  //     title: titlecontroller.text,
                                  //     date: datecontroller.text,
                                  //     time: timecontroller.text)
                                  .then((eventId) {
                                print("eventId " + eventId.toString());
                                //NOTE set Notification for event
                                NotificationApi.scheduleNotification(
                                    DateTime.parse(datecontroller.text +
                                            " " +
                                            time.toString())
                                        .subtract(Duration(
                                            minutes: int.parse(todocontroller
                                                .selectedRemindItem.value))),
                                    eventId,
                                    titlecontroller.text,
                                    timecontroller.text);
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
