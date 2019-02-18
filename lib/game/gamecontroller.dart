import 'package:flutter/material.dart';

import './nimgame.dart';
import './item_widget.dart';
import '../state/game_bloc.dart';

class GameController extends StatefulWidget {
  State<StatefulWidget> createState() {
    return GameControllerState();
  }
}

class GameControllerState extends State {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GlobalBloc.stream,
      builder: (BuildContext context, AsyncSnapshot<NIMGame> gameData) {
        if (gameData.hasData) {
          if (gameData.data.winner == null) {
            return _buildPiles(gameData.data);
          } else {
            return _buildWinner(gameData.data);
          }
        } else {
          return _buildLoading();
        }
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
