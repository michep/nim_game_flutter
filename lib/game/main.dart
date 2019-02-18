import 'dart:io';

import './nimgame.dart';
import './nimai.dart';

main() {
  var misere = true;
  var game = NIMGame(NIMGameType.pvc, NIMPlayer.player1, NIMDifficulty.easy, false, [1, 1, 2]);
  var ai = NIMGameAI(NIMDifficulty.insane, misere);
  if (misere) print("!!! MISERE !!!");

  while (game.winner == null) {
    print(game);
    switch (game.currentPlayer) {
      case NIMPlayer.player1:
      case NIMPlayer.player2:
        playerTurn(game);
        // aiTurn(game, ai);
        break;
      default:
        aiTurn(game, ai);
    }
    game.switchSides();
  }
  print("${game.winner} is the winner");
}

playerTurn(NIMGame game) {
  print("\n${game.currentPlayer}'s turn");
  print("Heap num:");
  var heapIdx = int.parse(stdin.readLineSync());
  print("Remove:");
  var toRemove = int.parse(stdin.readLineSync());
  var turn = NIMGameTurn(heapIdx, toRemove);
  print(turn);
  game.applyTurn(turn);
}

aiTurn(NIMGame game, NIMGameAI ai) {
  print("\n${game.currentPlayer}'s turn");
  var turn = ai.makeTurn(game.state);
  print(turn);
  game.applyTurn(turn);
  // stdin.readLineSync();
}
