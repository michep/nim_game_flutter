enum GameType { pvp, pvc }
enum Player { player1, player2, ai }
enum ElementState { present, toRemove, empty }
enum Difficulty { easy, hard, insane }

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
    ret.write("Taking ${toRemove} from ${pile}");
    return ret.toString();
  }
}

class NIMGamePile {
  List<ElementState> _elements;

  NIMGamePile.allPresent(int count) {
    _elements = List<ElementState>(count);
    for (var idx = 0; idx < count; idx++) {
      _elements[idx] = ElementState.present;
    }
  }

  List<ElementState> get elements => _elements;

  operator [](int idx) => _elements[idx];

  int get length => _elements.length;

  int get activeCount {
    int count = 0;
    _elements.forEach((e) => e == ElementState.present ? count++ : count);
    return count;
  }

  void removeFromStart(int count) {
    assert(count > 0 && count <= activeCount);
    var n = 0;
    for (var e = 0; e < length; e++) {
      if (n == count) break;
      if (_elements[e] == ElementState.present) {
        _elements[e] = ElementState.empty;
        n++;
      }
    }
  }

  void removeFromEnd(int count) {
    assert(count > 0 && count <= activeCount);
    var n = 0;
    for (var e = length-1; e >= 0; e--) {
      if (n == count) break;
      if (_elements[e] == ElementState.present) {
        _elements[e] = ElementState.empty;
        n++;
      }
    }
  }
}

class NIMGamePiles {
  List<NIMGamePile> _piles;

  NIMGamePiles(List<int> initPiles) {
    _piles = List<NIMGamePile>(initPiles.length);
    for (var idx = 0; idx < initPiles.length; idx++) {
      _piles[idx] = NIMGamePile.allPresent(initPiles[idx]);
    }
  }

  // int totalCountRow(int i) => _heaps[i].length;
  // int activeCountRow(int i) => _heaps[i].activeCount;
  int get length => _piles.length;

  bool get isEmpty {
    for (var idx = 0; idx < _piles.length; idx++) {
      if (_piles[idx].activeCount != 0) return false;
    }
    return true;
  }

  NIMGamePile operator [](int idx) => _piles[idx];
}

class NIMGame {
  GameType _gameType;
  Player _currentPlayer;
  Player _prevPlayer;
  Player _winner;
  NIMGamePiles _piles;
  bool _misere;
  bool _fromStart = true;


  Player get currentPlayer => _currentPlayer;
  Player get winner => _winner;

  NIMGame.usual() {
    _gameType = GameType.pvc;
    _currentPlayer = Player.player1;
    _piles = NIMGamePiles([3, 5, 7]);
  }

  NIMGame(GameType gameType, Player firstTurn, bool misere, List<int> initPiles) {
    _gameType = gameType;
    _currentPlayer = firstTurn;
    _piles = NIMGamePiles(initPiles);
    _misere = misere;
  }

  List<NIMGamePile> get piles => _piles._piles;

  void switchSides() {
    _prevPlayer = _currentPlayer;
    if (_gameType == GameType.pvp) {
      if (_currentPlayer == Player.player1)
        _currentPlayer = Player.player2;
      else
        _currentPlayer = Player.player1;
    } else {
      if (_currentPlayer == Player.player1)
        _currentPlayer = Player.ai;
      else
        _currentPlayer = Player.player1;
    }
  }

  NIMGameState get state {
    var ret = List<int>(_piles.length);
    for (var idx = 0; idx < _piles.length; idx++) {
      ret[idx] = _piles[idx].activeCount;
    }
    return NIMGameState(ret);
  }

  bool applyTurn(NIMGameTurn turn) {
    if (_fromStart) {
      _piles[turn.pile].removeFromStart(turn.toRemove);
    } else {
      _piles[turn.pile].removeFromEnd(turn.toRemove);
    }
    _fromStart = !_fromStart;
    if (_piles.isEmpty) {
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
          case ElementState.empty:
            ret.write("- ");
            break;
          case ElementState.toRemove:
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
