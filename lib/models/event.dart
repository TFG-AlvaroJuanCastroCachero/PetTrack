import 'package:flutter/material.dart';

class EventCalendar {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  EventCalendar({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay = false,
  });
}
