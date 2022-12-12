import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/auth/RegisterPage.dart';
import 'package:tfg_proyect/auth/SignInPage.dart';
import 'package:tfg_proyect/pages/PaginaHome.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return PaginaHome();
    } else {
      if (showSignIn) {
        return SignInPage(toggleView: toggleView);
      } else {
        return RegisterPage(toggleView: toggleView);
      }
    }
  }
}
