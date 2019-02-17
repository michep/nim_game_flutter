import 'package:flutter/material.dart';

import './nimgame.dart';
import './item_widget.dart';
import '../state/game_bloc.dart';
import '../state/game_event.dart';

class GameController extends StatefulWidget {
  State<StatefulWidget> createState() {
    return GameControllerState();
  }
}

class GameControllerState extends State {
  NIMGame _game;
  GameStateBloc _bloc;

  GameControllerState() {
    _game = NIMGame(NIMGameType.pvp, NIMPlayer.player1, false, [3, 5, 10]);
    _bloc = GameStateBloc(_game);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.gameState,
      initialData: _game,
      builder: (BuildContext context, AsyncSnapshot<NIMGame> gameData) {
        if (gameData.data.winner == null) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  "${gameData.data.currentPlayerName}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(gameData.data.piles.length, (pileIdx) {
                  var pile = gameData.data.piles[pileIdx];
                  return Expanded(
                    // margin: EdgeInsets.all(32),
                    child: Column(
                      children: List<Widget>.generate(pile.elements.length,
                          (itemIdx) => ItemWidget(_bloc, pileIdx, itemIdx, pile.elements[itemIdx])),
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
                      onPressed: () => _bloc.gameEventSink.add(NIMEndTurnEvent()),
                    )
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "The WINNER is ${gameData.data.winner}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ]);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
