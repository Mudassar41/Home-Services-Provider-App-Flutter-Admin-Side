import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sizing {
  static double screenWidth;
  static double screenHeight;
  static double blockWidth = 0;
  static double blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 480) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;

      isPortrait = false;
      isMobilePortrait = false;
    }

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    textMultiplier = blockHeight;
    imageSizeMultiplier = blockHeight;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;
    //print(screenWidth);
   // print(heightMultiplier);
  }
}
