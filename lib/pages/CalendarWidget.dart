import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tfg_proyect/models/event_data_source.dart';
import 'package:tfg_proyect/pages/TasksWidget.dart';
import 'package:tfg_proyect/provider/event_provider.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      showNavigationArrow: true,
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
    );
  }
}
