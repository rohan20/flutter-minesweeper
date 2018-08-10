import 'package:flutter/material.dart';
import 'package:minesweeper/widget/game_board.dart';

//covered tile = un-opened tile
enum TileState { covered, blown, open, flagged, revealed }

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Minesweeper"),
        ),
        body: GameBoard(),
      ),
    );
  }
}
