import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final database = FirebaseDatabase.instance.reference();
  User? user = FirebaseAuth.instance.currentUser;
  String? _error;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? get error => _error;

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Singed in";
    } on FirebaseAuthException catch (e) {
      // throw e;
      print("error register: $e");
      return e.message.toString();
    }
    // catch (e) {
    //   return e.message.toString();
    // }
  }

  Future changeEmail(String newEmail, String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? oldEmail = user?.email.toString();
    print("oldEmail: $oldEmail");
    UserCredential? authResult = await user?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: oldEmail.toString(),
        password: password,
      ),
    );
    try {
      var message = "asdf";
// Then use the newly re-authenticated user
      authResult?.user
          ?.updateEmail(newEmail)
          .then(
            (value) => message = 'Success',
          )
          .catchError((onError) => message = 'error');
      print("message update email: $message");
    } on FirebaseAuthException catch (e) {
      // throw e;
      print("error update email: $e");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("You have to sing in again to update the email")));
      return e.message.toString();
    }

    // try {
    //   _firebaseAuth.signInWithEmailAndPassword(
    //       email: newEmail, password: password).then(function(userCredential) {
    //     userCredential.user.updateEmail('newyou@domain.example')
    // })
    // } on FirebaseAuthException catch (e) {
    //   // throw e;
    //   print("error update email: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text("You have to sing in again to update the email")));
    //   return e.message.toString();
    // }
    // try {
    //   var message;
    //   print("user: $user");
    //   user?.updateEmail(newEmail).then(
    //         (value) => message = 'Success',
    //       );
    //   // .catchError((onError) => message = 'error');
    //   return message;
    // } on FirebaseAuthException catch (e) {
    //   // throw e;
    //   print("error update email: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text("You have to sing in again to update the email")));
    //   return e.message.toString();
    // }
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String petName}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        database
            .child("Usuario")
            .child(result.user!.uid)
            .set({'Email': email, 'PetName': petName, 'Password': password});
      });
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print("error register: $e");
      return e.message.toString();
    }
    // catch (e) {
    //   return e.message.toString();
    // }
  }
}
