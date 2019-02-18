import 'package:rxdart/rxdart.dart';

import '../game/nimgame.dart';

abstract class NIMGameEvent {}

class NIMTapOnItemEvent extends NIMGameEvent {
  final int pile, item;
  NIMTapOnItemEvent(this.pile, this.item);
}

class NIMEndTurnEvent extends NIMGameEvent {}

class NIMNewSettingsEvent extends NIMGameEvent {
  final NIMGameSettings settings;
  NIMNewSettingsEvent(this.settings);
}

class GameStateBloc {
  NIMGame _game;
  NIMGameSettings _settings = NIMGameSettings();
  int workingPile = -1;

  static final GameStateBloc _bloc = GameStateBloc._internal();

  GameStateBloc._internal() {
    _eventController.stream.listen(_mapEventToGameState);
  }

  factory GameStateBloc() {
    return _bloc;
  }

  var _eventController = BehaviorSubject<NIMGameEvent>();
  var _gameController = BehaviorSubject<NIMGame>();

  Function(NIMGameEvent) get push => _eventController.sink.add;
  Stream<NIMGame> get stream => _gameController;

  void _mapEventToGameState(NIMGameEvent event) {
    switch (event.runtimeType) {
      case NIMTapOnItemEvent:
        _processTapEvent(event);
        break;
      case NIMEndTurnEvent:
        _processEndTurnEvent(event);
        break;
      case NIMNewSettingsEvent:
        _processewSettingsEvent(event);
        break;
      default:
        print("Unknown event");
    }
    _gameController.add(_game);
  }

  void _processTapEvent(NIMTapOnItemEvent event) {
    var currentItemState = _game.piles[event.pile][event.item];
    var markingToDelete = currentItemState == NIMElementState.present;
    print("event NIMTapOnItemEvent: pile ${event.pile}, item ${event.item}");
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

  void _processEndTurnEvent(NIMEndTurnEvent event) {
    if (workingPile == -1) {
      print("ERROR: no selected items");
      return;
    }
    print("event NIMEndTurnEvent");
    workingPile = -1;
    _game.applyToRemove();
    _game.switchSides();
  }

  void _processewSettingsEvent(NIMNewSettingsEvent event) {
    print("event NIMNewSettingsEvent");
    _settings = event.settings;
    _game = NIMGame.withSettings(_settings);
  }

  void dispose() {
    _eventController.close();
    _gameController.close();
  }
}

final GameStateBloc GlobalBloc = GameStateBloc();
