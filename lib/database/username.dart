import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final User user = FirebaseAuth.instance.currentUser;
final database = FirebaseDatabase.instance.reference();

Future<String> getUsername() async {
  String username;

  await database
      .child('Usuario')
      .child(user.uid)
      .once()
      .then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, value) {
      if (key == 'Username') {
        username = value;
        print(username);
      }
    });
  });

  return username;
}
