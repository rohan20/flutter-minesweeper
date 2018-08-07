import 'package:flutter/material.dart';
import 'package:minesweeper/game_page.dart';
import 'package:minesweeper/widget/tiles/game_board_covered_mine_tile.dart';
import 'package:minesweeper/widget/tiles/game_board_open_mine_tile.dart';
import 'package:minesweeper/widget/tiles/game_board_tile.dart';
import 'dart:math';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final int numOfRows = 9;
  final int numOfColumns = 9;
  final int numOfMines = 11;

  List<List<TileState>> gameTilesState;
  List<List<bool>> gameTilesMineStatus;

  void resetBoard() {
    //2D list for tile status (covered/blown/open/flagged/revealed)
    gameTilesState = List<List<TileState>>.generate(numOfRows, (row) {
      return List<TileState>.filled(numOfColumns, TileState.blown);
    });

    //2D list for tile mine status (true for mine, false for normal)
    gameTilesMineStatus = List<List<bool>>.generate(numOfRows, (row) {
      return List<bool>.filled(numOfColumns, false);
    });

    //logic to place mines on the game board
    Random random = Random();
    int remainingNumOfMines = numOfMines;

    while (remainingNumOfMines > 0) {
      int positionOfMine = random.nextInt(numOfRows * numOfColumns);
      int rowIndexOfMine = positionOfMine ~/ numOfRows;
      int columnIndexOfMine = positionOfMine % numOfColumns;

      //check if new position doesn't have a mine already
      if (!gameTilesMineStatus[rowIndexOfMine][columnIndexOfMine]) {
        gameTilesMineStatus[rowIndexOfMine][columnIndexOfMine] = true;
        remainingNumOfMines--;
      }
    }
  }

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  Widget buildBoard() {
    List<Row> gameBoardRow = <Row>[];

    for (int i = 0; i < numOfRows; i++) {
      List<Widget> rowChildren = <Widget>[];

      for (int j = 0; j < numOfColumns; j++) {
        TileState tileState = gameTilesState[i][j];

        if (tileState == TileState.covered || tileState == TileState.flagged) {
          rowChildren.add(
            Tile(
              child: CoveredMineTile(
                flagged: tileState == TileState.flagged,
                posX: i,
                posY: j,
              ),
            ),
          );
        } else {
          rowChildren.add(
            OpenMineTile(
              state: tileState,
              surroundingMinesCount: 1,
            ),
          );
        }
      }

      gameBoardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(i),
      ));
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: gameBoardRow,
      ),
    );
  }

  /*
  Check if the tile tapped lies inside the board or not. This is needed so that
  you don't have to do extra handling in the surroundingMinesCount() method when
  x or y become < 0 or greater than numOfColumns/numOfRows.
   */
  bool isInBoard(int x, int y) =>
      x > 0 && x < numOfColumns && y > 0 && y < numOfRows;

  /*
  Check if the current tile has a mine or not. If it is, return 1 else return 0.
  Return 1 so that this can help with the surroundingMinesCount() method. 
   */
  int isAMine(int x, int y) =>
      isInBoard(x, y) && gameTilesMineStatus[y][x] ? 1 : 0;

  /*
  Calculate the number of mines around a tile. The count would act as the number
  to be displayed on the tile
   */
  int surroundingMinesCount(int x, int y) {
    int count = 0;

    //check left column
    count += isAMine(x - 1, y - 1);
    count += isAMine(x - 1, y);
    count += isAMine(x - 1, y + 1);

    //check same column
    count += isAMine(x, y - 1);
    count += isAMine(x, y + 1);

    //check right column
    count += isAMine(x + 1, y - 1);
    count += isAMine(x + 1, y);
    count += isAMine(x + 1, y + 1);

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: buildBoard(),
      ),
    );
  }
}
