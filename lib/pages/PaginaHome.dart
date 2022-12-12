import 'package:flutter/material.dart';
import 'package:tfg_proyect/pages/PaginaEstadisticas.dart';

import 'PaginaCalendar.dart';
import 'PaginaMapa.dart';
import 'PaginaPerfil.dart';

class PaginaHome extends StatefulWidget {
  @override
  _PaginaHomeState createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  int _paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    List<Widget> _paginas = [
      PaginaEstadisticas(),
      PaginaMapa(),
      PaginaCalendar(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect'),
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Profile'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaPerfil()),
              );
            },
            color: Colors.teal[400],
            // onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        currentIndex: _paginaActual,
        selectedItemColor: Colors.teal[400],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Statistics"),
          // Icon(Icons.assessment)
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "I'm here!"),
          // location_on_rounded
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Event"),
          // medical_services_outlined
        ],
      ),
    );
  }
}
