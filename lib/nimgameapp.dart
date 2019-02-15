import 'package:flutter/material.dart';

import 'startpage.dart';

class NimGameApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NIM Game',
      home: StartPage(),
    );
  }
}