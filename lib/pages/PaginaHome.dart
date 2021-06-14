import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tfg_proyect/pages/PaginaEstadisticas.dart';
import 'package:tfg_proyect/pages/PaginaVacuna.dart';

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
      PaginaVacuna(),
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
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.supervised_user_circle),
      //   backgroundColor: Colors.teal[200],
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => PaginaPerfil()),
      //     );
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
    );
  }
}

// class _PaginaHomeState extends State<PaginaHome> {
//   @override
//   Widget build(BuildContext context) {
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//     int _paginaActual = 1;

//     List<Widget> _paginas = [
//       PaginaEstadisticas(),
//       // PaginaHome(),
//       PaginaVacuna(),
//       PaginaVacuna(),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TFG proyect'),
//         backgroundColor: Colors.teal[400],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.supervised_user_circle),
//         backgroundColor: Colors.teal[200],
//         onPressed: () {},
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//       body: _paginas[_paginaActual],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (index) {
//           setState(() {
//             _paginaActual = index;
//           });
//         },
//         currentIndex: _paginaActual,
//         selectedItemColor: Colors.teal[400],
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.analytics), label: "Estadísticas"),
//           // Icon(Icons.assessment)
//           BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Home"),
//           // location_on_rounded
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today), label: "Vacuna"),
//           // medical_services_outlined
//         ],
//       ),
//     );
//   }
// }

// class PaginaHome extends StatelessWidget {
//   const PaginaHome({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // return Center(
//     //   child: Text(
//     //     "Home",
//     //     style: TextStyle(fontSize: 30),
//     //   ),
//     // );
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//     int _paginaActual = 0;

//     List<Widget> _paginas = [
//       PaginaEstadisticas(),
//       PaginaHome(),
//       PaginaVacuna(),
//     ];
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'TFG proyect',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('TFG proyect'),
//           backgroundColor: Colors.teal[400],
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.supervised_user_circle),
//           backgroundColor: Colors.teal[200],
//           onPressed: () {},
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//         body: _paginas[_paginaActual],
//         bottomNavigationBar: BottomNavigationBar(
//           onTap: (index) {
//             setState(() {
//               _paginaActual = index;
//             });
//           },
//           currentIndex: _paginaActual,
//           selectedItemColor: Colors.teal[400],
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.analytics), label: "Estadísticas"),
//             // Icon(Icons.assessment)
//             BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Home"),
//             // location_on_rounded
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_today), label: "Vacuna"),
//             // medical_services_outlined
//           ],
//         ),
//       ),
//     );
//   }
// }
