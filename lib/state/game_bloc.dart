import 'dart:async';

import './game_event.dart';
import '../game/nimgame.dart';

class GameStateBloc {
  NIMGame _game;
  int workingPile = -1;

  final _gameStateController = StreamController<NIMGame>();
  StreamSink<NIMGame> get _inboudGameState => _gameStateController.sink;
  Stream<NIMGame> get gameState => _gameStateController.stream;

  final _gameEvenController = StreamController<NIMGameEvent>();
  Sink<NIMGameEvent> get gameEventSink => _gameEvenController.sink;

  GameStateBloc(NIMGame game) {
    _game = game;
    _gameEvenController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(NIMGameEvent event) {
    switch (event.runtimeType) {
      case NIMTapOnItemEvent:
        print("event NIMTapOnItemEvent: pile ${(event as NIMTapOnItemEvent).pile}, item ${(event as NIMTapOnItemEvent).item}");
        _processTapEvent(event);
        break;
      case NIMEndTurnEvent:
        print("event NIMEndTurnEvent");
        workingPile = -1;
        _game.applyToRemove();
        _game.switchSides();
        break;
      default:
        print("Unknown event");
    }
    _inboudGameState.add(_game);
  }

  void _processTapEvent(NIMTapOnItemEvent event) {
    var currentItemState = _game.piles[event.pile][event.item];
    var markingToDelete = currentItemState == NIMElementState.present;
    if (currentItemState == NIMElementState.empty) {
      print("ERROR: item is already removed");
      return;
    }
    if (workingPile == -1) {
      workingPile = event.pile;
    }
    if ((workingPile != -1) && (_game.piles[event.pile].toRemoveCount == 1) && !markingToDelete) {
      _game.piles[event.pile].switchElementState(event.item);
      workingPile = -1;
      return;
    }
    if (workingPile == event.pile) {
      _game.piles[event.pile].switchElementState(event.item);
      return;
    }
    if (workingPile != event.pile) {
      print("ERROR: wrong pile");
    } 
  }

  void dispose() {
    _gameStateController.close();
    _gameEvenController.close();
  }
}
