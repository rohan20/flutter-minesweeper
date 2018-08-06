import 'package:flutter/material.dart';

class InnerTile extends StatelessWidget {
  final Widget child;
  final Color color;

  InnerTile({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      height: 30.0,
      width: 30.0,
      child: child,
      color: color == null ? Colors.grey[100] : color,
    );
  }
}
