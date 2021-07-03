import 'dart:async';
import 'dart:convert';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ServiceProvidersProfileProvider extends ChangeNotifier {
  List<ProfileModel> _providerProfileList = [];
  StreamController<List<ProfileModel>> streamController;
  Stream stream;

  Future<List<ProfileModel>> get providerProfileList async =>
      _providerProfileList;
  SharePrefService sharePrefService = SharePrefService();

  Future<List<ProfileModel>> getProvidersprofileData() async {
    String Id = await sharePrefService.getcurrentUserId();
    final response = await http
        .get(Uri.parse('http://192.168.43.113:4000/getProvidersProfile/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      // print(data);
      List<ProfileModel> profileList = data
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();
      _providerProfileList.add(data);
      notifyListeners();

      return profileList;
    }
  }
}
