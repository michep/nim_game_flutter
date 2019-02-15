import 'package:flutter/material.dart';

import 'gamecontroller.dart';

class GamePage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game"),
      ),
      body: GameController(),
    );
  }
}
