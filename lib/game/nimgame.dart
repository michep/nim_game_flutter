enum NIMGameType { pvp, pvc }
enum NIMPlayer { player1, player2, ai }
enum NIMElementState { present, toRemove, empty }
enum NIMDifficulty { easy, hard, insane }

class NIMGameSettings {
  final NIMGameType gameType;
  final NIMPlayer firstTurn;
  final NIMDifficulty difficulty;
  final List<int> initPiles;
  final bool misere;
  final String playerName1;
  final String playerName2;

  NIMGameSettings({
    this.gameType = NIMGameType.pvp,
    this.firstTurn = NIMPlayer.player1,
    this.difficulty = NIMDifficulty.easy,
    this.misere = false,
    this.playerName1 = "Player 1",
    this.playerName2 = "Player 2",
    this.initPiles,
  });
}

class NIMGameState {
  final List<int> piles;

  NIMGameState(this.piles);

  int nimnum() {
    int nimnum = 0;
    piles.forEach((p) => nimnum = nimnum ^ p);
    return nimnum;
  }

  int nonZeroPilesCount() {
    int count = 0;
    piles.forEach((p) => p > 0 ? count++ : count);
    return count;
  }
}

class NIMGameTurn {
  final int pile;
  final int toRemove;
  NIMGameTurn(this.pile, this.toRemove);

  @override
  String toString() {
    StringBuffer ret = StringBuffer("");
    ret.write("Taking $toRemove from $pile");
    return ret.toString();
  }
}

class NIMGamePile {
  List<NIMElementState> _elements;

  NIMGamePile.allPresent(int count) {
    _elements = List<NIMElementState>.generate(count, (idx) => NIMElementState.present);
  }

  List<NIMElementState> get elements => _elements;

  operator [](int idx) => _elements[idx];

  int get length => _elements.length;

  int get activeCount {
    int count = 0;
    _elements.forEach((e) => e == NIMElementState.present ? count++ : count);
    return count;
  }

  int get toRemoveCount {
    int count = 0;
    _elements.forEach((e) => e == NIMElementState.toRemove ? count++ : count);
    return count;
  }

  void switchElementState(int idx) {
    switch (_elements[idx]) {
      case NIMElementState.present:
        _elements[idx] = NIMElementState.toRemove;
        break;
      case NIMElementState.toRemove:
        _elements[idx] = NIMElementState.present;
        break;
      default:
    }
  }

  void removeFromStart(int count) {
    assert(count > 0 && count <= activeCount);
    var n = 0;
    for (var e = 0; e < length; e++) {
      if (n == count) break;
      if (_elements[e] == NIMElementState.present) {
        _elements[e] = NIMElementState.empty;
        n++;
      }
    }
  }

  void removeFromEnd(int count) {
    assert(count > 0 && count <= activeCount);
    var n = 0;
    for (var e = length - 1; e >= 0; e--) {
      if (n == count) break;
      if (_elements[e] == NIMElementState.present) {
        _elements[e] = NIMElementState.empty;
        n++;
      }
    }
  }
}

class NIMGame {
  NIMGameType _gameType;
  NIMPlayer _currentPlayer;
  NIMPlayer _prevPlayer;
  NIMPlayer _winner;
  List<NIMGamePile> _piles;
  NIMDifficulty _difficulty;
  bool _misere;
  bool _fromStart = true;
  String _playerName1;
  String _playerName2;

  NIMPlayer get currentPlayer => _currentPlayer;

  NIMPlayer get winner => _winner;

  String get winnerName {
    switch (_winner) {
      case NIMPlayer.player1:
        return _playerName1;
      case NIMPlayer.player2:
        return _playerName2;
      default:
        return "NIM AI";
    }
  }

  String get currentPlayerName {
    switch (_currentPlayer) {
      case NIMPlayer.player1:
        return _playerName1;
      case NIMPlayer.player2:
        return _playerName2;
      default:
        return "NIM AI";
    }
  }

  NIMGame.withSettings(NIMGameSettings settings) {
    _gameType = settings.gameType;
    _currentPlayer = settings.firstTurn;
    _difficulty = settings.difficulty;
    _misere = settings.misere;
    _piles = _initPiles(settings.initPiles);
    _playerName1 = settings.playerName1;
    _playerName2 = settings.playerName2;
  }

  NIMGame.usual() {
    _gameType = NIMGameType.pvc;
    _currentPlayer = NIMPlayer.player1;
    _difficulty = NIMDifficulty.easy;
    _piles = _initPiles([3, 5, 7]);
    _playerName1 = "Player 1";
    _playerName2 = "player 2";
  }

  NIMGame(NIMGameType gameType, NIMPlayer firstTurn, NIMDifficulty difficulty, bool misere, List<int> initPiles,
      {String playerName1 = "Player 1", String playerName2 = "Player 2"}) {
    _gameType = gameType;
    _currentPlayer = firstTurn;
    _difficulty = difficulty;
    _piles = _initPiles(initPiles);
    _misere = misere;
    _playerName1 = playerName1;
    _playerName2 = playerName2;
  }

  List<NIMGamePile> get piles => _piles;

  List<NIMGamePile> _initPiles(List<int> initPiles) {
    return List<NIMGamePile>.generate(initPiles.length, (idx) => NIMGamePile.allPresent(initPiles[idx]));
  }

  bool get isEmpty {
    for (var idx = 0; idx < _piles.length; idx++) {
      if (_piles[idx].activeCount != 0) return false;
    }
    return true;
  }

  void switchSides() {
    _prevPlayer = _currentPlayer;
    if (_gameType == NIMGameType.pvp) {
      if (_currentPlayer == NIMPlayer.player1)
        _currentPlayer = NIMPlayer.player2;
      else
        _currentPlayer = NIMPlayer.player1;
    } else {
      if (_currentPlayer == NIMPlayer.player1)
        _currentPlayer = NIMPlayer.ai;
      else
        _currentPlayer = NIMPlayer.player1;
    }
  }

  NIMGamePile operator [](int idx) => _piles[idx];

  NIMGameState get state {
    var ret = List<int>(_piles.length);
    for (var idx = 0; idx < _piles.length; idx++) {
      ret[idx] = _piles[idx].activeCount;
    }
    return NIMGameState(ret);
  }

  bool applyToRemove() {
    for (var pi = 0; pi < _piles.length; pi++) {
      for (var ei = 0; ei < _piles[pi]._elements.length; ei++) {
        if (_piles[pi]._elements[ei] == NIMElementState.toRemove) _piles[pi]._elements[ei] = NIMElementState.empty;
      }
    }
    if (isEmpty) {
      _winner = _currentPlayer;
      if (_misere) {
        _winner = _prevPlayer;
      }
      return true;
    }
    return false;
  }

  bool applyTurn(NIMGameTurn turn) {
    if (_fromStart) {
      _piles[turn.pile].removeFromStart(turn.toRemove);
    } else {
      _piles[turn.pile].removeFromEnd(turn.toRemove);
    }
    _fromStart = !_fromStart;
    if (isEmpty) {
      _winner = _currentPlayer;
      if (_misere) {
        _winner = _prevPlayer;
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    StringBuffer ret = StringBuffer("");
    ret.writeln("\nCURRENT GAME POSITION");
    for (var h = 0; h < _piles.length; h++) {
      ret.writeln("PILE ${h}");
      ret.write("[" + "${_piles[h].activeCount}".padLeft(2) + "] ");
      for (var e = 0; e < _piles[h].length; e++) {
        switch (_piles[h][e]) {
          case NIMElementState.empty:
            ret.write("- ");
            break;
          case NIMElementState.toRemove:
            ret.write("O ");
            break;
          default:
            ret.write("X ");
        }
      }
      ret.writeln("");
      ret.writeln("");
    }
    ret.writeln("nim-num = ${state.nimnum()}");
    ret.writeln("");
    return ret.toString();
  }
}
