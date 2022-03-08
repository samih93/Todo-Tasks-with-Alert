import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_tasks_with_alert/model/event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(
        getEvent(index).date.toString() + " " + getEvent(index).starttime);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(
        getEvent(index).date.toString() + " " + getEvent(index).endtime);
  }

  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }

  // @override
  // Color getColor(int index) {
  //   return Colors.accents;
  // }

  // @override
  // bool isAllDay(int index) {
  //   return _getMeetingData(index).isAllDay;
  // }
}
