import 'package:flutter/material.dart';

class PaginaHome extends StatelessWidget {
  const PaginaHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Home",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
