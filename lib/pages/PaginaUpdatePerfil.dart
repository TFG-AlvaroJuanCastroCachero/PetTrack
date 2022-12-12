import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tfg_proyect/pages/PaginaPerfil.dart';
import '../auth/Authentication_service.dart';
import 'package:provider/provider.dart';

class PaginaUpdatePerfil extends StatefulWidget {
  @override
  _PaginaPerfilState createState() => _PaginaPerfilState();
}

class _PaginaPerfilState extends State<PaginaUpdatePerfil> {
  final User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.reference();
  final TextEditingController changePetName = TextEditingController();
  final TextEditingController changeUserEmail = TextEditingController();

  String petName = "";
  String userEmail = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    database
        .child('Usuario')
        .child(user!.uid)
        .once()
        .then((DatabaseEvent databbdd) {
      DataSnapshot dataSnapshot = databbdd.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map;

      values.forEach((key, value) {
        if (key == 'Email') {
          userEmail = value;

          print("emailtest: " + userEmail);
        }
        if (key == 'PetName') {
          petName = value;
          print(petName);
        }
        if (key == 'Password') {
          password = value;
          print(password);
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect - Update Perfil'),
        backgroundColor: Colors.teal[400],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => PaginaPerfil())));
            }),
      ),
      body: Container(
        margin: EdgeInsets.all(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) => value!.length < 6
                  ? 'Enter a password with 6 or more characters'
                  : null,
              controller: changePetName,
              decoration: InputDecoration(
                  labelText: "Change your pet name",
                  contentPadding: new EdgeInsets.symmetric(horizontal: 30),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40))),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (changePetName.text.isNotEmpty) {
                    database
                        .child("Usuario")
                        .child(user!.uid)
                        .child('PetName')
                        .set(changePetName.text);

                    changePetName.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Updated pet name")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pet name can not be empty")));
                  }
                },
                child: Text('Update pet name'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            TextFormField(
              validator: (value) => value!.length < 6
                  ? 'Enter a password with 6 or more characters'
                  : null,
              controller: changeUserEmail,
              decoration: InputDecoration(
                labelText: "Change your user email",
                contentPadding: new EdgeInsets.symmetric(horizontal: 30),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // if (_formKey.currentState.validate()) {
                  if (changeUserEmail.text.isNotEmpty &&
                          changeUserEmail.text.contains("@gmail.com") ||
                      changeUserEmail.text.contains("@hotmail.es") ||
                      changeUserEmail.text.contains("hotmail.es")) {
                    try {
                      await context
                          .read<AuthenticationService>()
                          .changeEmail(changeUserEmail.text, password);
                    } on FirebaseAuthException catch (e) {
                      print("error update email: $e");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "You have to sing in again to update the email")));
                    }

                    database
                        .child("Usuario")
                        .child(user!.uid)
                        .child('Email')
                        .set(changeUserEmail.text.trim());

                    changeUserEmail.clear();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Updated email")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("The email address is badly formatted")));
                  }
                },
                child: Text("Update email"),
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
