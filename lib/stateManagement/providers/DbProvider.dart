import 'dart:convert';

import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DatabaseProvider extends ChangeNotifier {
  List<ProfileModel> _list = [];

  List<ProfileModel> get list => _list;

  Future<List<ProfileModel>> getlist() async => _list;

  set list(List<ProfileModel> value) {
    _list = value;
    notifyListeners();
  }
}
