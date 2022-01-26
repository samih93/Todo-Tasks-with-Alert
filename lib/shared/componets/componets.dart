//NOTE ----------Build Task Item -----------------------------
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

Widget buildTaskItem(Map task) => GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      // NOTE Dismissible to
      builder: (todocontroller) => InkWell(
        onTap: () {
          print("On Tapped " + task['id'].toString());
          //  _showBottomSheet(context: context, builder: task);
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: defaultLightColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${task['title']}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${DateFormat.yMMMd().format(DateTime.parse(task['date'].toString().split(' ').first))}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${task['time']}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       IconButton(
            //           onPressed: () {
            //             todocontroller.updatestatusTask(
            //                 taskId: task["id"].toString(), status: "done");
            //           },
            //           icon: Icon(Icons.check_box,
            //               color: Get.isDarkMode
            //                   ? defaultDarkColor
            //                   : defaultLightColor)),
            //       IconButton(
            //           onPressed: () {
            //             todocontroller.updatestatusTask(
            //                 taskId: task["id"].toString(), status: "archive");
            //           },
            //           icon: Icon(Icons.archive,
            //               color: Get.isDarkMode
            //                   ? defaultDarkColor
            //                   : defaultLightColor)),
            //     ],
            //   ),
            // ),
          ],
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
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: buildTaskItem(tasks[index]),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
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

//NOTE ----------default Button -----------------------------
Widget defaultButton(
        {double width = double.infinity,
        Color background = Colors.blue,
        VoidCallback? onpress,
        required String text,
        double radius = 0,
        double height = 40,
        bool? isUppercase}) =>
    Container(
      width: width,
      child: MaterialButton(
        height: height,
        onPressed: onpress,
        child: Text(
          (isUppercase != null && isUppercase) ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );
