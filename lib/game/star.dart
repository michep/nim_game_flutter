import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("TAP"),
      child: Icon(
        Icons.star,
        size: 36,
        // icon: Icon(Icons.star),
        // iconSize: Size.fromRadius(24).width,
        // onPressed: () {},
      ),
    );
  }
}
