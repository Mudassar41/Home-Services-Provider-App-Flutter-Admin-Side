import 'package:flutter/material.dart';

import 'customColors.dart';

class FormFieldDesign {
  static inputDecoration(dynamic labeltext, dynamic icon) {
    return InputDecoration(
        focusedErrorBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
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
        labelText: labeltext,
        // isCollapsed: true,

        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ));
  }
}
