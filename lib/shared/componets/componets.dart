//NOTE ----------Build Task Item -----------------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

Widget buildTaskItem(Map map) => GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      // NOTE Dismissible to
      builder: (todocontroller) => Dismissible(
        key: Key(map['id']),
        onDismissed: (direction) {
          todocontroller.deleteTask(taskId: map['id'].toString());
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                child: Text(
                  "${map['time']}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${map['title']}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "${map['date']}",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        onPressed: () {
                          todocontroller.updatestatusTask(
                              taskId: map["id"].toString(), status: "done");
                        },
                        icon: Icon(Icons.check_box,
                            color: Get.isDarkMode
                                ? defaultDarkColor
                                : defaultLightColor)),
                    IconButton(
                        onPressed: () {
                          todocontroller.updatestatusTask(
                              taskId: map["id"].toString(), status: "archive");
                        },
                        icon: Icon(Icons.archive,
                            color: Get.isDarkMode
                                ? defaultDarkColor
                                : defaultLightColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

//NOTE ----------Build Task Builder -----------------------------
// circular indicator then show list of tasks or archived taks or finished task
Widget tasksBuilder({required List<Map> tasks, required String message}) =>
    tasks.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu, size: 60, color: Colors.grey),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$message",
                  style: TextStyle(fontSize: 23, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index]),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 1,
                ),
            itemCount: tasks.length);

//NOTE ----------My Divider -----------------------------
Widget myDivider() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 1,
    );

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType inputtype,
        Function(String?)? onfieldsubmit,
        VoidCallback? ontap,
        String? Function(String?)? onvalidate,
        Function(String?)? onchange,
        String? text,
        Widget? prefixIcon,
        Widget? suffixIcon,
        bool obscure = false,
        InputBorder? border,
        String? hinttext,
        int? maxligne,
        bool readonly = false}) =>
    TextFormField(
        controller: controller,
        keyboardType: inputtype,
        onFieldSubmitted: onfieldsubmit,
        onTap: ontap,
        maxLines: maxligne ?? 1,
        readOnly: readonly,
        obscureText: obscure,
        onChanged: onchange,
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          labelText: text,
          hintText: hinttext ?? null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: border ?? OutlineInputBorder(),
        ),
        validator: onvalidate);
