import 'package:flutter/cupertino.dart';

class PhoneAuthProvidr extends ChangeNotifier {
  dynamic _verificationId;

  dynamic get verificationId => _verificationId;

  set verificationId(dynamic value) {
    _verificationId = value;
    notifyListeners();
  }
}
