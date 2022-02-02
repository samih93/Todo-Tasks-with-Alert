import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_tasks_with_alert/model/event.dart';
import 'package:todo_tasks_with_alert/model/event_metting_data_source.dart';
import 'package:todo_tasks_with_alert/shared/componets/componets.dart';

class SearchEvents extends StatelessWidget {
  var _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: defaultTextFormField(
              controller: _searchController,
              text: "Search for a event",
              inputtype: TextInputType.name,
              border: InputBorder.none,
              onchange: (value) {}),
        ),
        body: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ));
  }
}
