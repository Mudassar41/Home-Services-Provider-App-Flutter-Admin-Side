import 'package:flutter/cupertino.dart';

class CurrentUserIdState extends ChangeNotifier {

String _currentUserId;
 String get currentUserId => this._currentUserId;

 set currentUserId(String value) {
   this._currentUserId = value;
   notifyListeners();
 } 



}