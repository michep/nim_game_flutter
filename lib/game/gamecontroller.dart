import 'package:flutter/material.dart';

import './nimgame.dart';
import './itemwidget.dart';
import '../state/gamebloc.dart';

class GameController extends StatefulWidget {
  @override
  State<GameController> createState() => GameControllerState();
}

class GameControllerState extends State<GameController> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GlobalBloc.gamestream,
      builder: (BuildContext context, AsyncSnapshot<NIMGame> gameData) {
        if (!gameData.hasData) {
          return _buildLoading();
        }
        if (gameData.data.winner != null) {
          return _buildWinner(gameData.data);
        }
        if (gameData.data.currentPlayer == NIMPlayer.ai) {
          return AbsorbPointer(
            child: _buildPiles(gameData.data),
          );
        }
        return _buildPiles(gameData.data);
      },
    );
  }

  Widget _buildPiles(NIMGame game) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "${game.currentPlayerName}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(game.piles.length, (pileIdx) {
            var pile = game.piles[pileIdx];
            return Expanded(
              // margin: EdgeInsets.all(32),
              child: Column(
                children: List<Widget>.generate(pile.elements.length,
                    (itemIdx) => ItemWidget(GlobalBloc, pileIdx, itemIdx, pile.elements[itemIdx])),
              ),
            );
          }),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RaisedButton(
                child: Text("End turn"),
                onPressed: () => GlobalBloc.push(NIMEndTurnEvent()),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWinner(NIMGame game) {
    return Center(
      child: Text(
        "The WINNER is ${game.winnerName}",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Text("Loading..."),
    );
  }
}
