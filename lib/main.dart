import 'package:flutter/material.dart';
import 'package:tfg_proyect/pages/PaginaEstadisticas.dart';
import 'package:tfg_proyect/pages/PaginaHome.dart';
import 'package:tfg_proyect/pages/PaginaVacuna.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _paginaActual = 0;

  List<Widget> _paginas = [
    PaginaEstadisticas(),
    PaginaHome(),
    PaginaVacuna(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFG proyect',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TFG proyect'),
          backgroundColor: Colors.teal[400],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.supervised_user_circle),
          backgroundColor: Colors.teal[200],
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                icon: Icon(Icons.analytics), label: "Estadísticas"),
            // Icon(Icons.assessment)
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Home"),
            // location_on_rounded
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Vacuna"),
            // medical_services_outlined
          ],
        ),
      ),
    );
  }
}
