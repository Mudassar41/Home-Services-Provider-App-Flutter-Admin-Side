import 'dart:async';
import 'dart:convert';

import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class ProviderProfilesController extends GetxController {
  SharePrefService sharePrefService = SharePrefService();
  var id = ''.obs;
  var length = 0.obs;
  ApiServices apiServices = ApiServices();
  var isLoading = true.obs;
  var profilesList = Future.value(<ProfileModel>[]).obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
