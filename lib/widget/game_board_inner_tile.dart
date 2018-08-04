import 'package:flutter/material.dart';

class BoardInnerTile extends StatefulWidget {
  @override
  _BoardInnerTileState createState() => _BoardInnerTileState();
}

class _BoardInnerTileState extends State<BoardInnerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      margin: const EdgeInsets.all(2.0),
      height: 25.0,
      width: 25.0,
    );
  }
}
