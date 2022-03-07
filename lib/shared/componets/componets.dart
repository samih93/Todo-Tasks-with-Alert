//NOTE ----------Build Task Item -----------------------------
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/model/event.dart';
import 'package:todo_tasks_with_alert/shared/styles/styles.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildEventItem(Event task, BuildContext context) =>
    GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      // NOTE Dismissible to
      builder: (todocontroller) => InkWell(
        onTap: () {
          print("On Tapped " + task.id.toString());
          _showBottomSheet(context, task);
        },
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: orangeGradient),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${task.title}",
                                  style: titleofTaskitem,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${DateFormat.yMMMd().format(DateTime.parse(task.date.toString().split(' ').first))}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
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
                              //NOTE 24 hours to am pm
                              Text(
                                "${DateFormat("h:mm a").format(DateTime.parse("2022-10-10 " + task.starttime.toString())).toString()} - ${DateFormat("h:mm a").format(DateTime.parse("2022-10-10 " + task.endtime.toString())).toString()}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.more_horiz, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

//NOTE ----------Build Task Builder -----------------------------
// circular indicator then show list of tasks or archived taks or finished task
Widget eventsBuilder({
  required List<Event> tasks,
  required String message,
  required BuildContext context,
  required String svgimage,
}) =>
    tasks.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: SvgPicture.asset(svgimage)),
              SizedBox(
                height: 10,
              ),
              Text(
                "$message",
                style: TextStyle(fontSize: 23, color: Colors.grey),
              ),
            ],
          )
        : ListView.separated(
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: buildEventItem(tasks[index], context),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: tasks.length);

_showBottomSheet(BuildContext context, Event event) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(25),
      height: event.status == "new"
          ? MediaQuery.of(context).size.height * 0.32
          : event.status == "done"
              ? MediaQuery.of(context).size.height * 0.24
              // if archived
              : MediaQuery.of(context).size.height * 0.15,
      color: Get.isDarkMode ? darkmodeColor : Colors.white,
      child: _bottomSheetbuttons(event),
    ),
  );
}

_bottomSheetbuttons(Event event) {
  TodoLayoutController todocontroller = Get.find<TodoLayoutController>();
  return event.status == "new"
      ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            defaultButton(
                text: 'Done',
                background: Colors.blue.shade400,
                radius: 15,
                onpress: () {
                  todocontroller.updatestatusevent(
                      eventId: event.id.toString(), status: "done");
                  Get.back();
                }),
            defaultButton(
                text: 'Archive',
                background: Colors.grey.shade400,
                radius: 15,
                onpress: () {
                  todocontroller.updatestatusevent(
                      eventId: event.id.toString(), status: "archive");
                  Get.back();
                }),
            defaultButton(
                text: 'Delete',
                background: Colors.red.shade400,
                radius: 15,
                onpress: () {
                  todocontroller.deleteEvent(eventId: event.id);
                  Get.back();
                }),
          ],
        )
      : event.status == "done"
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                defaultButton(
                    text: 'Archive',
                    background: Colors.grey.shade400,
                    radius: 15,
                    onpress: () {
                      todocontroller.updatestatusevent(
                          eventId: event.id.toString(), status: "archive");
                      Get.back();
                    }),
                defaultButton(
                    text: 'Delete',
                    background: Colors.red.shade400,
                    radius: 15,
                    onpress: () {
                      todocontroller.deleteEvent(eventId: event.id);
                      Get.back();
                    }),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                defaultButton(
                    text: 'Delete',
                    background: Colors.red.shade400,
                    radius: 15,
                    onpress: () {
                      todocontroller.deleteEvent(eventId: event.id);
                      Get.back();
                    }),
              ],
            );
}

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
        LinearGradient? gradient,
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
          gradient: gradient),
    );
