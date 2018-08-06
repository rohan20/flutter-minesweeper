import 'package:flutter/material.dart';
import 'package:minesweeper/widget/game_board_inner_tile.dart';
import 'package:minesweeper/widget/game_board_tile.dart';

class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int posX;
  final int posY;

  CoveredMineTile({this.flagged, this.posX, this.posY});

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: InnerTile(
        child: flagged
            ? Center(
                child: Text(
                  "F",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : InnerTile(),
      ),
    );
  }
}
