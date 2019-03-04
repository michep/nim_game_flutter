import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../game/nimgame.dart';
import '../game/nimai.dart';

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

class NIMAITurnEvent extends NIMGameEvent {
  final NIMGameTurn turn;
  NIMAITurnEvent(this.turn);
}

class GameStateBloc {
  NIMGameSettings _settings;
  NIMGame _game;
  NIMGameAI _ai;
  int workingPile = -1;

  static final GameStateBloc _bloc = GameStateBloc._internal();

  GameStateBloc._internal() {
    _settings = NIMGameSettings(
      initPiles: [3, 5, 7],
      gameType: NIMGameType.pvc,
    );
    _game = NIMGame.withSettings(_settings);
    _ai = NIMGameAI.withSettings(_settings);
    push(NIMNewSettingsEvent(_settings));
    _eventController.stream.listen(_mapEventToGameState);
  }

  factory GameStateBloc() {
    return _bloc;
  }

  var _eventController = BehaviorSubject<NIMGameEvent>();
  var _gameController = BehaviorSubject<NIMGame>();
  var _settingsController = BehaviorSubject<NIMGameSettings>();

  Function(NIMGameEvent) get push => _eventController.sink.add;
  Stream<NIMGame> get gamestream$ => _gameController.stream;
  Stream<NIMGameSettings> get settingsstream$ => _settingsController.stream;

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
      case NIMAITurnEvent:
        _processAITurnEvent(event);
        break;
      default:
        print("Unknown event");
    }
    _gameController.add(_game);
  }

  void _processTapEvent(NIMTapOnItemEvent event) {
    var currentItemState = _game.piles[event.pile][event.item];
    print("event NIMTapOnItemEvent: pile ${event.pile}, item ${event.item}");
    if (currentItemState == NIMElementState.empty) {
      print("ERROR: item is already removed");
      return;
    }
    if (workingPile == -1) {
      workingPile = event.pile;
    }
    if ((workingPile != -1) &&
        (_game.piles[event.pile].toRemoveCount == 1) &&
        (currentItemState != NIMElementState.present)) {
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
    if (_game.currentPlayer == NIMPlayer.ai && _game.winner == null) {
      Timer(Duration(seconds: 2), () {
        var turn = _ai.makeTurn(_game.state);
        GlobalBloc.push(NIMAITurnEvent(turn));
      });
    }
  }

  void _processewSettingsEvent(NIMNewSettingsEvent event) {
    print("event NIMNewSettingsEvent");
    _settings = event.settings;
    _game = NIMGame.withSettings(_settings);
    _ai = NIMGameAI.withSettings(_settings);
    _settingsController.add(_settings);
  }

  void _processAITurnEvent(NIMAITurnEvent event) {
    print("event NIMAITurnEvent");
    _game.applyTurn(event.turn);
    _game.switchSides();
  }

  void dispose() {
    _eventController.close();
    _gameController.close();
  }
}

final GameStateBloc GlobalBloc = GameStateBloc();
