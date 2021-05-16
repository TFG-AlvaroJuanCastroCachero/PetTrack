import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PaginaVacuna extends StatelessWidget {
  const PaginaVacuna({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(1990),
        lastDay: DateTime(2050),
      ),
    );
  }
}
