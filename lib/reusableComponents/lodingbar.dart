import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  @override
  _LoadingBarState createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationAnimation(100, 100),
      ),
    );
  }
}
