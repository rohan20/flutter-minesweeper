import 'package:flutter/material.dart';

enum TileState { covered, blown, open, flagged, revealed }

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Minesweeper"),
        ),
        body: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final int numOfRows = 9;
  final int numOfColumns = 9;
  final int numOfMines = 11;

  List<List<TileState>> gameTilesState;

  void resetBoard() {
    gameTilesState = List<List<TileState>>.generate(numOfRows, (row) {
      return List<TileState>.filled(numOfColumns, TileState.covered);
    });
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

        if (tileState == TileState.covered) {
          rowChildren.add(
            GameBoardTile(),
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

class GameBoardTile extends StatefulWidget {
  @override
  _GameBoardTileState createState() => _GameBoardTileState();
}

class _GameBoardTileState extends State<GameBoardTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(1.0),
        height: 35.0,
        width: 35.0,
        color: Colors.grey[400],
      ),
    );
  }
}
