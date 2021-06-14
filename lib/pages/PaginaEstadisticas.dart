import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tfg_proyect/auth/Authentication_service.dart';
import 'package:tfg_proyect/database/username.dart';

class PaginaEstadisticas extends StatelessWidget {
  // const PaginaEstadisticas({Key key}) : super(key: key);

  final database = FirebaseDatabase.instance.reference();
  final User user = FirebaseAuth.instance.currentUser;
  final TextEditingController changeUsername = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String username;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("ESTADÍSTICAS"),
            Text(
              user.uid,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) => value.length < 6
                  ? 'Enter a password with 6 or more characters'
                  : null,
              controller: changeUsername,
              decoration: InputDecoration(
                labelText: "Change your username",
              ),
            ),
            RaisedButton(
              onPressed: () {
                // if (_formKey.currentState.validate()) {
                // var leerId = database.once().then((DataSnapshot snapshot) {
                //   print('Data: ${snapshot.value}');
                // });
                // getUsername();

                database
                    .child("Usuario")
                    .child(user.uid)
                    .child('Username')
                    .set(changeUsername.text.trim());

                // database
                //     .child('Usuario')
                //     .child(user.uid)
                //     .once()
                //     .then((DataSnapshot snapshot) {
                //   Map<dynamic, dynamic> values = snapshot.value;
                //   values.forEach((key, value) {
                //     // Usuario user = new Usuario(
                //     //   values[key]["Email"],
                //     //   values[key]["Username"],
                //     // );
                //     if (key == 'Username') {
                //       username = value;
                //       print(username);
                //     }
                //   });
                // });
              },
              child: Text("Modify database"),
            ),
          ],
        ),
      ),
    );
  }
}

// child: Text(
//         "Estadisticas",
//         style: TextStyle(fontSize: 30),
//       ),
