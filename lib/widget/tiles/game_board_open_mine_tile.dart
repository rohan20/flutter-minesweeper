import 'package:flutter/material.dart';
import 'package:minesweeper/game_page.dart';
import 'package:minesweeper/widget/tiles/game_board_inner_tile.dart';
import 'package:minesweeper/widget/tiles/game_board_tile.dart';

/*
OpenMineTile = Open (Shows surroundingMinesCount), Blown or Revealed
 */
class OpenMineTile extends StatelessWidget {
  final TileState state;
  final int surroundingMinesCount;

  OpenMineTile({this.state, this.surroundingMinesCount});

  final List textColorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    Widget text;

    if (state == TileState.open) {
      if (surroundingMinesCount != 0) {
        text = Text(
          "$surroundingMinesCount",
          style: TextStyle(
            color: textColorsList[surroundingMinesCount - 1],
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        );
      }
    } else {
      text = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "\u2620",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Tile(
      child: Center(child: text),
    );
  }
}
