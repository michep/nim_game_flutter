import 'package:flutter/material.dart';

import './nimgame.dart';
import './star.dart';

class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NIMGame _game = NIMGame(GameType.pvp, Player.player1, false, [3, 5, 9]);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _game.piles
              .map(
                (pile) => Container(
                      margin: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                          border: new Border(
                        right: BorderSide(width: 1),
                        left: BorderSide(width: 1),
                      )),
                      child: Column(
                        children: pile.elements.map((element) => Star()).toList(),
                      ),
                    ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("End turn"),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  }
}
