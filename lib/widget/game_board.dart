import 'dart:async';

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

  bool isUserAlive;
  bool hasUserWonGame;
  int minesFound;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resetBoard() {
    isUserAlive = true;
    hasUserWonGame = false;
    minesFound = 0;
    stopwatch.reset();

    //cancel the timer if it was running previously
    timer?.cancel();
    //the callback method just invokes setState() because we want the time to update
    //every second
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {});
      },
    );

    //2D list for tile status (covered/blown/open/flagged/revealed)
    gameTilesState = List<List<TileState>>.generate(numOfRows, (row) {
      return List<TileState>.filled(numOfColumns, TileState.covered);
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
    //covered tile = un-opened tile
    bool doesBoardHaveACoveredTile = false;

    List<Row> gameBoardRow = <Row>[];

    for (int y = 0; y < numOfRows; y++) {
      List<Widget> rowChildren = <Widget>[];

      for (int x = 0; x < numOfColumns; x++) {
        TileState tileState = gameTilesState[y][x];
        int minesNearMeCount = surroundingMinesCount(x, y);

        //reveal all mines if user has clicked on a mine
        if (!isUserAlive) {
          if (tileState != TileState.blown)
            //if the current tile has a mine, reveal it, else let it be
            tileState =
                gameTilesMineStatus[y][x] ? TileState.revealed : tileState;
        }

        if (tileState == TileState.covered || tileState == TileState.flagged) {
          rowChildren.add(
            GestureDetector(
              onTap: () {
                //allow user to click a tile only if it is covered (so that
                //we can't click on flagged tiles)
                if (tileState == TileState.covered) tapTile(x, y);
              },
              onLongPress: () {
                flag(x, y);
              },
              child: Tile(
                child: CoveredMineTile(
                  flagged: tileState == TileState.flagged,
                  posX: y,
                  posY: x,
                ),
              ),
            ),
          );

          //if there are any tiles that are covered (haven't been opened or
          //revealed yet), then doesBoardHaveACoveredTile is true
          if (tileState == TileState.covered) {
            doesBoardHaveACoveredTile = true;
          }
        } else {
          rowChildren.add(
            OpenMineTile(
              state: tileState,
              surroundingMinesCount: minesNearMeCount,
            ),
          );
        }
      }

      gameBoardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(y),
      ));

      //the user can win the game only when you've opened all the tiles and
      //marked all mine tiles as flagged
      if (!doesBoardHaveACoveredTile) {
        if ((minesFound == numOfMines) && isUserAlive) {
          hasUserWonGame = true;
          stopwatch.stop();
        }
      }
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
      x >= 0 && x < numOfColumns && y >= 0 && y < numOfRows;

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

  void flag(int x, int y) {
    if (!isUserAlive) {
      return;
    }

    setState(() {
      if (gameTilesState[y][x] == TileState.flagged) {
        gameTilesState[y][x] = TileState.covered;
        minesFound--;
      } else {
        gameTilesState[y][x] = TileState.flagged;
        minesFound++;
      }
    });
  }

  void openTile(int x, int y) {
    //if the user clicks outside the board
    if (!isInBoard(x, y)) {
      return;
    }

    //if the user clicks an already opened tile
    if (gameTilesState[y][x] == TileState.open) {
      return;
    }

    gameTilesState[y][x] = TileState.open;

    //if you click a tile that has a number, the game would only open that tile.
    //But if you click an empty tile, then we want to open all tiles nearby
    // until we hit a tile that has a number
    if (surroundingMinesCount(x, y) > 0) {
      return;
    }

    //left column
    openTile(x - 1, y + 1);
    openTile(x - 1, y);
    openTile(x - 1, y - 1);

    //same column
    openTile(x, y + 1);
    openTile(x, y - 1);

    //right column
    openTile(x + 1, y + 1);
    openTile(x + 1, y);
    openTile(x + 1, y - 1);
  }

  void tapTile(int x, int y) {
    if (!isUserAlive) {
      return;
    }

    if (gameTilesState[y][x] == TileState.flagged) {
      return;
    }

    setState(() {
      if (gameTilesMineStatus[y][x]) {
        gameTilesState[y][x] = TileState.blown;
        isUserAlive = false;
        timer.cancel();
      } else {
        openTile(x, y);
        if (!stopwatch.isRunning) {
          stopwatch.start();
        }
      }
    });
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
