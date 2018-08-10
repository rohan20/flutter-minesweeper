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
    double dimen = (MediaQuery.of(context).size.width - 50.0) / 9;

    return GestureDetector(
      child: Container(
        child: widget.child,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(0.5),
        width: dimen,
        height: dimen,
        color: Colors.grey[400],
      ),
    );
  }
}
