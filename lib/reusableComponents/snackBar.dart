import 'package:flutter/material.dart';

class CustomSnackBar{


  static showSnackBar(String msg,BuildContext context){
   ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg),));
  }

}