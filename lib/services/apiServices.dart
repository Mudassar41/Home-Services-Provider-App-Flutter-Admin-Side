import 'dart:convert';
import 'dart:io';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/stateManagement/providers/currentuserState.dart';
import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/models/providerModel.dart';

import 'package:final_year_project/models/category.dart';

import 'package:dio/dio.dart';
import 'package:final_year_project/reusableComponents/customToast.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class ApiServices {
  static List<Categories> dogsBreedList = <Categories>[];
  static List<Categories> tempList = <Categories>[];
  static bool isLoading = false;
  var LoginLink = Uri.parse('http://192.168.43.113:4000/loginprovider');
  var providersDataLink = Uri.parse('http://192.168.43.113:4000/AddProviders');
  var providersprofileLink =
      Uri.parse('http://192.168.43.113:4000/addProvidersProfile');
  var getCategoriesUrl = Uri.parse('http://192.168.43.113:4000/getCats');

  Future<String> postPrvidersData(ProviderModel providerModel,
      ProgressDialog progressDialog, SharePrefService service) async {
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();
    try {
      var response = await http.post(providersDataLink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'providerFirstName': providerModel.firstName,
            'providerLastName': providerModel.lastName,
            'providerPhoneNumber': providerModel.phoneNumber,
            'providerPassword': providerModel.password,
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        res = value['msg'];
        service.addCurrentuserToSf(value['data']['_id']);
        progressDialog.hide();
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        res = value['msg'];
        progressDialog.hide();
      }
      return res;
    } catch (e) {
      print(e);
    }
  }

  Future<String> postPrvidersProfilesData(ProfileModel profileModel,
      ProgressDialog progressDialog, File image) async {
    //  var imagename = image.path.split('/').last;
    // String base64Image = base64Encode(image.readAsBytesSync());
    // print(base64Image);
    // List<int> imageBytes = image.readAsBytesSync();
    // String baseimage = base64Encode(imageBytes);
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();
    try {
      var response = await http.post(providersprofileLink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'catId': profileModel.catId,
            'shopImage': image,
            'shopName': profileModel.shopName,
            'address': profileModel.address,
            'whFromTime': profileModel.whFromTime,
            'whFromTimeType': profileModel.whFromTimeType,
            'whToTime': profileModel.whToTime,
            'whToTimeType': profileModel.whToTimeType,
            'wsTo': profileModel.wsTo,
            'longitude': profileModel.longitude,
            'latitude': profileModel.latitude,
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        res = value['msg'];
        progressDialog.hide();
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        res = value['msg'];
        print(res);
        progressDialog.hide();
      }
      return res;
    } catch (e) {
      print(e.toString());
      progressDialog.hide();
    }
  }

  Future<String> dioPrvidersProfilesData(ProfileModel profileModel,
      ProgressDialog progressDialog, File image, String userId) async {
    // profileModel.currentUid = userId;
    //
    print("current user id is ${userId}");
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();

    try {
      var dio = Dio();
      FormData formData = new FormData.fromMap({
        'serviceprovidersdatas': userId,
        'providercategories': profileModel.catId,
        'shopImage':
            await MultipartFile.fromFile(image.path, filename: image.path),
        'shopName': profileModel.shopName,
        'address': profileModel.address,
        'whFromTime': profileModel.whFromTime,
        'whFromTimeType': profileModel.whFromTimeType,
        'whToTime': profileModel.whToTime,
        'whToTimeType': profileModel.whToTimeType,
        'wsTo': profileModel.wsTo,
        'wsFrom': profileModel.wsFrom,
        'longitude': profileModel.longitude,
        'latitude': profileModel.latitude,
      });
      var response = await dio.post(
          'http://192.168.43.113:4000/addProvidersProfile',
          data: formData,
          options: Options(contentType: 'multipart/form-data'));
      if (response.statusCode == 200) {
        res = response.data['msg'];
        // var value = jsonDecode(response.data['msg']);
        // res = value;
        // print('This is response ${res}');
        progressDialog.hide();
      } else {
        // var value = jsonDecode(response.data);
        res = response.data['msg'];
        progressDialog.hide();
      }
      return res;
    } catch (e) {
      print('Error is ${e}');
      progressDialog.hide();
    }
  }

  static Future<List<Categories>> getCategiesData() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.113:4000/getCats'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      print(data);
      List<Categories> categoriesList =
          data.map<Categories>((json) => Categories.fromJson(json)).toList();
      return categoriesList;
    }
  }

  // ignore: missing_return
  static Future<List<ProfileModel>> getProvidersprofileData(String id) async {
    final response = await http
        .get(Uri.parse('http://192.168.43.113:4000/getProvidersProfile/${id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];

      List<ProfileModel> profileList = data
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();

      return profileList;
    }
  }

  static Future<List<Categories>> searchCategiesData(String text) async {
    final response = await http.get(
        Uri.parse('http://192.168.43.113:4000/search/${text.toLowerCase()}'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      List<Categories> categoriesList =
          data.map<Categories>((json) => Categories.fromJson(json)).toList();

      return categoriesList;
    }
  }

  Future<String> loginUser(SharePrefService sharePrefService,
      ProviderModel providerModel, ProgressDialog progressDialog) async {
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();
    try {
      var response = await http.post(LoginLink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'providerPhoneNumber': providerModel.phoneNumber,
            'providerPassword': providerModel.password,
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        res = value['msg'];
        var currentUserId = value['UserId']['_id'];
        sharePrefService.addCurrentuserToSf(currentUserId);
        print('id is ${currentUserId}');
        progressDialog.hide();
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        res = value['msg'];

        progressDialog.hide();
      }
      return res;
    } catch (e) {
      print(e);
      progressDialog.hide();
      CustomToast.showToast(e);
    }
  }
}
