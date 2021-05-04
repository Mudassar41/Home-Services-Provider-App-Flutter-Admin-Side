import 'package:flutter/material.dart';

import 'customColors.dart';

class VarificationFields {
  static varificationFieldDesign() {
    return InputDecoration(
      focusedErrorBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: CustomColors.lightGreen)),
      errorBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: CustomColors.lightGreen)),
      enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: CustomColors.lightGreen)),
      focusedBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: CustomColors.lightGreen)),
      labelStyle: TextStyle(color: Colors.grey),
    );
  }
}
