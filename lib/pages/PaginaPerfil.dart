import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/Authentication_service.dart';
import 'PaginaUpdatePerfil.dart';

class PaginaPerfil extends StatefulWidget {
  @override
  _PaginaPerfilState createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaPerfil> {
  final User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.ref();
  String petName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    database.child('Usuario').child(user!.uid).once().then((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map;
      print("values bbdd: $values");
      values.forEach((key, value) {
        if (key == 'Email') {
          userEmail = value;

          print("emailasdf: " + userEmail);
        }
        if (key == 'PetName') {
          petName = value;
          print(petName);
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect - Perfil'),
        backgroundColor: Colors.teal[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pet Name: " + petName.toString()),
            Padding(padding: EdgeInsets.all(10)),
            Text("Email: " + userEmail.toString()),
            Padding(padding: EdgeInsets.all(10)),
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => PaginaUpdatePerfil())));
                },
                child: Text("Update profile"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
