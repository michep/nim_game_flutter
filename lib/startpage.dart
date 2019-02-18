import 'package:flutter/material.dart';

import 'settings/settingspage.dart';
import 'game/gamepage.dart';

class StartPage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NIM Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Setting"),
              onPressed: _navigateToSettings(context),
            ),
            RaisedButton(
              child: Text("Start Game"),
              onPressed: _navigateToGame(context),
            )
          ],
        ),
      ),
    );
  }

  VoidCallback _navigateToSettings(BuildContext context) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
    };
  }

  VoidCallback _navigateToGame(BuildContext context) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage()));
    };
  }
}
