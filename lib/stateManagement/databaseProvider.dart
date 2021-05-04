import 'package:final_year_project/models/category.dart';
import 'package:flutter/cupertino.dart';

class DataBaseProvider extends ChangeNotifier{

  List<Categories> _listData=[];

  Future<List<Categories>> get listData  async => _listData;

  setlistData(List<Categories> value) {
    _listData = value;
    notifyListeners();
  }
}