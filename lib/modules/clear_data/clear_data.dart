import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_tasks_with_alert/layout/todo_layout.dart';
import 'package:todo_tasks_with_alert/layout/todo_layoutcontroller.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';
import 'package:todo_tasks_with_alert/shared/styles/thems.dart';

class ClearData extends StatefulWidget {
  @override
  State<ClearData> createState() => _ClearDataState();
}

class _ClearDataState extends State<ClearData> {
  var datecontroller = TextEditingController();
  var todocontroller = Get.find<TodoLayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clear Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "delete all events befor this date",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: 15,
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
                    datecontroller.text = value.toString().split(' ').first;
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
            defaultButton(
                text: "Delete",
                background: Colors.red,
                onpress: () async {
                  if (datecontroller.text.isEmpty ||
                      datecontroller.text.toString() == 'null') {
                    Get.snackbar('an error occured', 'Date must be not empty',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: defaultLightColor,
                        colorText: Colors.white);
                  } else {
                    await todocontroller
                        .deleteAllEventBefor(
                            DateTime.parse(datecontroller.text.toString()))
                        .then((value) {
                      Get.back();
                      Get.snackbar('Events Deleted Successfully',
                          'All events befor ${datecontroller.text} are Deleted',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade600,
                          colorText: Colors.white);
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
