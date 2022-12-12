import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/models/event.dart';
import 'package:tfg_proyect/pages/EventEditingPage.dart';
import 'package:tfg_proyect/provider/event_provider.dart';

class EventViewingPage extends StatelessWidget {
  final EventCalendar event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        leading: CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          // buildDateTime(event),
          SizedBox(height: 32),
          Text(
            event.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            "From: " +
                fechaYhoraFormato(event.from.day) +
                "/" +
                fechaYhoraFormato(event.from.month) +
                "/" +
                fechaYhoraFormato(event.from.year) +
                "    " +
                fechaYhoraFormato(event.from.hour) +
                ":" +
                fechaYhoraFormato(event.from.minute),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "To: " +
                fechaYhoraFormato(event.to.day) +
                "/" +
                fechaYhoraFormato(event.to.month) +
                "/" +
                fechaYhoraFormato(event.to.year) +
                "    " +
                fechaYhoraFormato(event.to.hour) +
                ":" +
                fechaYhoraFormato(event.to.minute),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  fechaYhoraFormato(evento) {
    String res = evento.toString();
    if (evento < 10) {
      res = "0" + evento.toString();
    }
    return res;
  }

  List<Widget> buildViewingActions(BuildContext context, EventCalendar event) =>
      [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.deleteEvent(event);
            Navigator.of(context).pop();
          },
        )
      ];
}
