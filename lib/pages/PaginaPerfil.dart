import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/database/username.dart';
import 'package:tfg_proyect/models/usuario.dart';

import '../auth/Authentication_service.dart';

class PaginaPerfil extends StatefulWidget {
  @override
  _PaginaPerfilState createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final User user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.reference();
  // List<Usuario> usuarios = [];
  String username;
  // String email =
  //     database.child("Usuario").child(user.uid).child("Email").once().value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database
        .child('Usuario')
        .child(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        // Usuario user = new Usuario(
        //   values[key]["Email"],
        //   values[key]["Username"],
        // );
        if (key == 'Username') {
          username = value;
          print(username);
        }
      });

      // var KEYS = snapshot.value.keys;
      // var DATA = snapshot.value;

      // usuarios.clear();

      // for (var individualkey in KEYS) {
      //   Usuario usuario = new Usuario(
      //     DATA[individualkey]["Email"],
      //     DATA[individualkey]["Username"],
      //   );
      //   usuarios.add(usuario);
      // }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect - Perfil'),
        backgroundColor: Colors.teal[400],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(username.toString()),
            Padding(padding: EdgeInsets.all(15)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.pop(context);
                },
                child: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
