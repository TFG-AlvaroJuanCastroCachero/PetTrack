import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tfg_proyect/models/event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventCalendar> appointments) {
    this.appointments = appointments;
  }

  EventCalendar getEvent(int index) => appointments![index] as EventCalendar;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}
