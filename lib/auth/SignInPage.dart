import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/auth/Authentication_service.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailControllerSingUp = TextEditingController();

  final TextEditingController passwordControllerSingUp =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect'),
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(15)),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
              },
              child: Text("Sign in"),
            ),
            // Padding(padding: EdgeInsets.all(15)),
            // TextField(
            //   controller: emailControllerSingUp,
            //   decoration: InputDecoration(
            //     labelText: "Email",
            //   ),
            // ),
            // TextField(
            //   controller: passwordControllerSingUp,
            //   decoration: InputDecoration(
            //     labelText: "Password",
            //   ),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     context.read<AuthenticationService>().signUp(
            //           email: emailController.text.trim(),
            //           password: passwordController.text.trim(),
            //         );
            //   },
            //   child: Text("Sign up"),
            // )
          ],
        ),
      ),
    );
  }
}
