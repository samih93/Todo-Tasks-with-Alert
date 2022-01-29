import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todoController) => tasksBuilder(
        tasks: todoController.newtask,
        context: context,
        message: "No Tasks yet, Add more Tasks",
        svgimage: "assets/new_task_svg.svg",
      ),
    );
  }
}
