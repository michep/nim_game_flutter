import 'package:flutter/material.dart';

import './nimgame.dart';
import '../state/game_bloc.dart';
import '../state/game_event.dart';

class ItemWidget extends StatelessWidget {
  final int pile, index;
  final NIMElementState state;
  final GameStateBloc bloc;

  ItemWidget(this.bloc, this.pile, this.index, this.state);

  IconData _getIconData() {
    switch (state) {
      case (NIMElementState.empty):
        return Icons.star_border;
        break;
      case (NIMElementState.toRemove):
        return Icons.star_half;
        break;
      default:
        return Icons.star;
    }

  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bloc.gameEventSink.add(NIMTapOnItemEvent(pile, index));
      },
      child: Container(
        padding: EdgeInsets.all(4),
        child: Icon(
          _getIconData(),
          size: 36,
          // icon: Icon(Icons.star),
          // iconSize: Size.fromRadius(24).width,
          // onPressed: () {},
        ),
      ),
    );
  }
}
