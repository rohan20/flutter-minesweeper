import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Minesweeper"),
        ),
        body: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}