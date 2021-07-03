import 'dart:convert';
import 'dart:io';
import 'package:final_year_project/models/tasksModel.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/models/providerModel.dart';
import 'package:final_year_project/models/category.dart';
import 'package:dio/dio.dart';
import 'package:final_year_project/stateManagement/providers/tasksProvider.dart';
import 'package:path/path.dart' as path;
import 'package:final_year_project/reusableComponents/customToast.dart';
import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:final_year_project/stateManagement/providers/DbProvider.dart';
import 'package:final_year_project/stateManagement/providers/serviceProvidersprofiles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';


class ApiServices {
///////////////////////////////////////////////////////////////////////

  var LoginLink = Uri.parse('http://192.168.18.100:4000/loginprovider');
  var providersDataLink = Uri.parse('http://192.168.18.100:4000/AddProviders');
  var providersprofileLink =
      Uri.parse('http://192.168.18.100:4000/addProvidersProfile');
  var getCategoriesUrl = Uri.parse('http://192.168.18.100:4000/getCats');
  SharePrefService sharePrefService = SharePrefService();
  var updateTaskslink = Uri.parse('http://192.168.18.100:4000/updateTasks');
  var giveRateReviewToUserLink =
      Uri.parse('http://192.168.18.100:4000//updateTasksForRateReviewUser');
  var updateImage = Uri.parse('http://192.168.18.100:4000/updateImageProvider');
/////////////////////////////////////////////////////////////////////////////
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
        service.addCurrentuserIdToSf(value['data']['_id']);
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
      ProgressDialog progressDialog, File image, String userId) async {
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();

    //Uploading Image to Firebase
    var fileExtension = path.extension(image.path);
    var uniqueId = Uuid().v4();
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('ServiceProviders/ShopImages$uniqueId$fileExtension');

    await firebaseStorageRef.putFile(image).then((result) {
      print('Uploaded');
    }).catchError((erorr) {
      print("Error in Uploading");
    });

    String url = await firebaseStorageRef.getDownloadURL();
    if (url != null) {
      print(url);
    }
    /////////////////////////////////////////////////////////////////

    try {
      var response = await http.post(providersprofileLink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'serviceprovidersdatas': userId,
            'providercategories': profileModel.catId,
            'shopImage': url,
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

  Future<String> dioPrvidersProfilesData(
    ProfileModel profileModel,
    ProgressDialog progressDialog,
    File image,
    String userId,
  ) async {
    print("current user id is ${userId}");
    print("location");
    print(profileModel.latitude);
    if (userId == null) {
      print('Id is null');
    }
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
          'http://192.168.18.100:4000/addProvidersProfile',
          data: formData,
          options: Options(contentType: 'multipart/form-data'));
      if (response.statusCode == 200) {
        res = response.data['msg'];
        //  controller.getProfilesData();
        // controller.update();
        progressDialog.hide();
      } else {
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
        await http.get(Uri.parse('http://192.168.18.100:4000/getCats'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      print(data);
      List<Categories> categoriesList =
          data.map<Categories>((json) => Categories.fromJson(json)).toList();
      return categoriesList;
    }
  }

  Future<List<ProfileModel>> getProvidersprofileData(
      DatabaseProvider provider) async {
    SharePrefService sharePrefService = SharePrefService();

    String Id = await sharePrefService.getcurrentUserId();
    final response = await http
        .get(Uri.parse('http://192.168.18.100:4000/getProvidersProfile/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      // print(data);
      List<ProfileModel> profileList = data
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();
      provider.list = profileList;
      return profileList;
    }
  }

  static Future<List<Categories>> searchCategiesData(String text) async {
    final response = await http.get(
        Uri.parse('http://192.168.18.100:4000/search/${text.toLowerCase()}'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      List<Categories> categoriesList =
          data.map<Categories>((json) => Categories.fromJson(json)).toList();

      return categoriesList;
    }
  }

  Future<String> loginUser(
      SharePrefService sharePrefService,
      ProviderModel providerModel,
      ProgressDialog progressDialog,
      String countryCode) async {
    String res = '';
    providerModel.phoneNumber = '${countryCode}${providerModel.phoneNumber}';
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
        sharePrefService.addCurrentuserIdToSf(currentUserId);
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
      // print(e);
      progressDialog.hide();
      // CustomToast.showToast(e);
    }
  }

  Stream<List<ProfileModel>> getData = (() async* {
    print("yes");
    await Future<void>.delayed(const Duration(seconds: 1));
    SharePrefService sharePrefService = SharePrefService();
    String Id = await sharePrefService.getcurrentUserId();
    print(Id);
    final response = await http
        .get(Uri.parse('http://192.168.18.100:4000/getProvidersProfile/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value;
      //print(data);
      List<ProfileModel> profileList = data
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();

      yield profileList;
    }
    await Future<void>.delayed(const Duration(seconds: 1));
  })();

// Stream<List<Images>> bids = (() async* {
//   print("yes");
//   await Future<void>.delayed(const Duration(seconds: 1));
//   SharePrefService sharePrefService = SharePrefService();
//   String Id = await sharePrefService.getcurrentUserId();
//   print(Id);
//   Id = '60ab8ec8e9f9ec2538dd76fc';
//   final response = await http
//       .get(Uri.parse('http://okeyquotes.com/app/getall__qoutesof_day.php'));
//   if (response.statusCode == 200) {
//     var value = jsonDecode(response.body);
//     var data = value;
//     print(data);
//     List<Images> profileList =
//         data.map<Images>((json) => Images.fromJson(json)).toList();
//
//     yield profileList;
//   }
//   await Future<void>.delayed(const Duration(seconds: 1));
// })();
  Future<List<TasksModel>> getTasks(TasksProvider tasksProvider) async {
    String Id = await sharePrefService.getcurrentUserId();
    //  print(Id);
    final response = await http
        .get(Uri.parse('http://192.168.18.100:4000/getTasksforProvider/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      //  print(data);
      List<TasksModel> tasksList =
          data.map<TasksModel>((json) => TasksModel.fromJson(json)).toList();


      tasksProvider.tasksList = tasksList;
      return tasksList;
    }
  }

  Future<String> updateTask(String taskId, String offerStatus) async {
    String res;
    try {
      var response = await http.patch(updateTaskslink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'id': taskId,
            'offerStatus': offerStatus,
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        res = value['msg'];
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        res = value['msg'];
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<void> getSingleTasks(
      String offerId, TasksProvider tasksProvider) async {
    final response = await http
        .get(Uri.parse('http://192.168.18.100:4000/getSingleTask/${offerId}'));
    if (response.statusCode == 200) {
      var data = TasksModel.fromJson(jsonDecode(response.body));
      tasksProvider.tasksModel = data;
    }
  }

  Future<String> giveRateReviewToUser(
      String taskId, double userRating, String userReview) async {
    String res;
    try {
      var response = await http.patch(giveRateReviewToUserLink,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'id': taskId,
            'providerRating': userRating,
            'providerReview': userReview
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        res = value['msg'];
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        res = value['msg'];
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
  Future<ProviderModel> getCurrrentUserInfo(String id) async {
    final response = await http
        .get(Uri.parse('http://192.168.18.100:4000/getCurrentProviderInfo/${id}'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var parsedData = value['data'];
      print(parsedData);
      ProviderModel userProfile = ProviderModel();
      userProfile.firstName = parsedData['providerFirstName'];

      //  print('yes');
      // print(  userProfile.firstName);
      userProfile.lastName = parsedData['providerLastName'];
      userProfile.phoneNumber = parsedData['providerPhoneNumber'];
      userProfile.imageLink = parsedData['imageLink'];
      userProfile.id=parsedData['_id'];
      return userProfile;
    }
  }

  Future<void> updateProfileImage(String imageUrl, String userId) async {
    try {
      var response = await http.patch(updateImage,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'id': userId,
            'userImage': imageUrl,
          }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        CustomToast.showToast(value['msg']);
        //cureentUserController.getCurrentUserInfo();
      } else {
        var value = jsonDecode(response.body);
        print('result is ${value['msg']}');
        CustomToast.showToast(value['msg']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
