import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg_proyect/models/event.dart';

class EventProvider extends ChangeNotifier {
  final List<EventCalendar> _events = [];
  final database = FirebaseDatabase.instance.ref();
  final User? user = FirebaseAuth.instance.currentUser;

  List<EventCalendar> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  // List<EventCalendar> get eventsOfSelectedDate => _events;
  void listEventos() async {
    DatabaseEvent databbdd =
        await database.child("Usuario").child(user!.uid).child("Evento").once();

    DataSnapshot dataSnapshot = databbdd.snapshot;
    print("dataSnapshot listaEventos: $dataSnapshot.value");
  }

  List<EventCalendar> getEventsOfSelectedDate() {
    listEventos();
    print(_events);
    return _events;
  }

  void addEvent(EventCalendar event) {
    listEventos();
    database
        .child("Usuario")
        .child(user!.uid)
        .child("Evento")
        .child(event.title)
        .set({
      'Titulo': event.title,
      'fechaFrom': event.from.toString(),
      'fechaTo': event.to.toString(),
      'periocidad': 1,
    });

    _events.add(event);

    notifyListeners();
  }

  void editEvent(EventCalendar newEvent, EventCalendar oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  void deleteEvent(EventCalendar event) {
    _events.remove(event);

    notifyListeners();
  }
}
