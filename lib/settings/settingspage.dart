import 'package:flutter/material.dart';

import '../state/game_bloc.dart';
import '../game/nimgame.dart';

class SettingsPage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("SETTINGS"),
            RaisedButton(
              child: Text("PRESS ME"),
              onPressed: _commitSettings(context),
            )
          ],
        ),
      ),
    );
  }

  VoidCallback _commitSettings(BuildContext context) {
    return () {
      GlobalBloc.push(NIMNewSettingsEvent(NIMGameSettings(
          gameType: NIMGameType.pvp,
          firstTurn: NIMPlayer.player1,
          difficulty: NIMDifficulty.easy,
          misere: false,
          playerName1: "PLAYER 1",
          playerName2: "PLAYER 2",
          initPiles: [3, 5, 7])));
      Navigator.pop(context);
    };
  }
}
