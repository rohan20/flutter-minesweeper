import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  @override
  _GameBoardTileState createState() => _GameBoardTileState();
}

class _GameBoardTileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(1.0),
        height: 35.0,
        width: 35.0,
        color: Colors.grey[400],
      ),
    );
  }
}
