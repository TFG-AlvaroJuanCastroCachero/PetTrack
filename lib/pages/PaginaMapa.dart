import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tfg_proyect/auth/Authentication_service.dart';

class PaginaMapa extends StatelessWidget {
  // const PaginaEstadisticas({Key key}) : super(key: key);

  final referenceDatabase = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("MAPA"),
        ],
      ),
    );
  }
}

// child: Text(
//         "Estadisticas",
//         style: TextStyle(fontSize: 30),
//       ),
