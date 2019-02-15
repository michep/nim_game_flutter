import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("SETTINGS"),
          ],
        ),
      ),
    );
  }
}
