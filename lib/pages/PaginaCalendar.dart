import 'package:flutter/material.dart';
import 'package:tfg_proyect/pages/CalendarWidget.dart';

import 'EventEditingPage.dart';

class PaginaCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal[400],
      onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventEditingPage())),
      ),
    );
  }
}
