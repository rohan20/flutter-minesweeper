import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final Widget child;

  Tile({this.child});

  @override
  _GameBoardTileState createState() => _GameBoardTileState();
}

class _GameBoardTileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: widget.child,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(2.0),
        height: 35.0,
        width: 35.0,
        color: Colors.grey[400],
      ),
    );
  }
}
