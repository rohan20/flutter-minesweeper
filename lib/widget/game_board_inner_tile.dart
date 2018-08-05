import 'package:flutter/material.dart';

class GameBoardInnerTile extends StatelessWidget {
  final Widget child;

  GameBoardInnerTile({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      margin: const EdgeInsets.all(2.0),
      height: 25.0,
      width: 25.0,
      child: child,
    );
  }
}
