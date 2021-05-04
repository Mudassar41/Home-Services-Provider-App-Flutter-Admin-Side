import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {

  User _user;


  Future<User> getuser()async => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }


}
