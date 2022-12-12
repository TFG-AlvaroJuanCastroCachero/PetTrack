import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_proyect/auth/Authentication_service.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({required this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final database = FirebaseDatabase.instance.reference();
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFG proyect'),
        backgroundColor: Colors.teal[400],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(15)),
              TextFormField(
                validator: (value) =>
                    value!.isNotEmpty && value.contains("@gmail.com") ||
                            value.contains("@hotmail.es") ||
                            value.contains("hotmail.es")
                        ? null
                        : 'Enter a correct email',
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Enter a pet name' : null,
                controller: petNameController,
                decoration: InputDecoration(
                  labelText: "Pet name",
                ),
              ),
              TextFormField(
                validator: (value) => value!.length < 6
                    ? 'Enter a password with 6 or more characters'
                    : null,
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<AuthenticationService>()
                        .signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            petName: petNameController.text.trim())
                        .then((value) {
                      if (value != "Signed up") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(value)));
                      }
                    });
                  }
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
