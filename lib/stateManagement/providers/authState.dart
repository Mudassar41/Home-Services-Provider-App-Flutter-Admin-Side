import 'package:flutter/cupertino.dart';

class AuthState extends ChangeNotifier {
  bool _loggedUser;

  bool get loggedUser => this._loggedUser;

  set loggedUser(bool value) {
    this._loggedUser = value;
    notifyListeners();
  }
}
