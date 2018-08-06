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

  @override
  Widget build(BuildContext context) {
    Widget text;

    if (state == TileState.open) {
      if (surroundingMinesCount != 0) {
        text = Text(
          "$surroundingMinesCount",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    } else {
      text = Text(
        "M",
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }

    return Tile(
      child: Center(child: text),
    );
  }
}
