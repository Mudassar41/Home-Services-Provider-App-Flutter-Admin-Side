import 'dart:async';
import 'dart:convert';

import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/models/providersData.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class ProviderProfilesController extends GetxController {
  SharePrefService sharePrefService = SharePrefService();
  var id = ''.obs;
  var profileList = <ProvidersData>[].obs;
  ApiServices apiServices = ApiServices();
  var isLoading = false.obs;

  getData() async {
    isLoading(true);
    var dataList = await apiServices.getProviderProfileData(id.value);
    profileList(dataList);
    print(profileList);
    isLoading(false);
  }

  @override
  void refresh() {
    // TODO: implement refresh
    super.refresh();
    getData();
  }
}
