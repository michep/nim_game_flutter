import 'dart:math';

import './nimgame.dart';

class NIMGameAI {
  Random _rnd = Random(DateTime.now().microsecondsSinceEpoch);
  NIMDifficulty _difficulty;
  bool _misere;
  NIMGameState _state;

  NIMGameAI.withSettings(NIMGameSettings settings) {
    _difficulty = settings.difficulty;
    _misere = settings.misere;
  }

  NIMGameAI(NIMDifficulty difficulty, bool misere) {
    _difficulty = difficulty;
    _misere = misere;
  }

  NIMGameTurn makeTurn(NIMGameState state) {
    _state = state;
    bool rand = false;
    int level = _rnd.nextInt(100);
    if ((_difficulty == NIMDifficulty.easy && level < 70) || (_difficulty == NIMDifficulty.hard && level < 40)) {
      rand = true;
    }
    if (rand) {
      return _removeItemsRandom(0);
    } else {
      return _removeItems();
    }
  }

  bool _nearEndgame() {
    var count = 0;
    _state.piles.forEach((p) => p > 1 ? count++ : count);
    return count <= 1;
  }

  NIMGameTurn _removeItems() {
    int pileIdx, toRemove, maxIdx, count = 0, max = -1;
    if (_misere && _nearEndgame()) {
      _state.piles.forEach((p) => p > 0 ? count++ : count);
      var isodd = (count % 2 == 1);
      for (pileIdx = 0; pileIdx < _state.piles.length; pileIdx++) {
        if (max < _state.piles[pileIdx]) {
          max = _state.piles[pileIdx];
          maxIdx = pileIdx;
        }
      }
      if ((max == 1) && (isodd)) {
        return _removeItemsRandom(1);
      }
      return NIMGameTurn(maxIdx, max - (isodd ? 1 : 0));
    }
    var nimnum = _state.nimnum();
    if (nimnum == 0) {
      return _removeItemsRandom(1);
    }
    for (pileIdx = 0; pileIdx < _state.piles.length; pileIdx++) {
      count = _state.piles[pileIdx];
      var rowxor = count ^ nimnum;
      if (rowxor < count) {
        toRemove = count - rowxor;
        break;
      }
    }
    return NIMGameTurn(pileIdx, toRemove);
  }

  NIMGameTurn _removeItemsRandom(int max) {
    int pile;
    int toRemove;
    while (true) {
      pile = _rnd.nextInt(_state.piles.length);
      if (_state.piles[pile] > 0) break;
    }
    if (_state.piles[pile] == 1) {
      toRemove = 1;
    } else {
      toRemove = _rnd.nextInt(_state.piles[pile] - 1) + 1;
    }
    if (toRemove > max && max > 0) toRemove = max;
    return NIMGameTurn(pile, toRemove);
  }
}
