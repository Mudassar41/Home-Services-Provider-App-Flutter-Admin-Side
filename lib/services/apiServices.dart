import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/chatModel.dart';
import 'package:final_year_project/models/providersData.dart';
import 'package:final_year_project/models/tasksModel.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/models/providerModel.dart';
import 'package:final_year_project/models/category.dart';
import 'package:dio/dio.dart';
import 'package:final_year_project/stateManagement/providers/chatProvider.dart';
import 'package:final_year_project/stateManagement/providers/tasksProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  var LoginLink = Uri.parse('http://192.168.43.113:4000/loginprovider');
  var providersDataLink = Uri.parse('http://192.168.43.113:4000/AddProviders');
  var providersprofileLink =
      Uri.parse('http://192.168.43.113:4000/addProvidersProfile');
  var getCategoriesUrl = Uri.parse('http://192.168.43.113:4000/getCats');
  SharePrefService sharePrefService = SharePrefService();
  var updateTaskslink = Uri.parse('http://192.168.43.113:4000/updateTasks');
  var giveRateReviewToUserLink =
      Uri.parse('http://192.168.43.113:4000/updateTasksForRateReviewUser');
  var updateImage = Uri.parse('http://192.168.43.113:4000/updateImageProvider');

/////////////////////////////////////////////////////////////////////////////
  Future<String> postPrvidersData(ProviderModel providerModel,
      ProgressDialog progressDialog, SharePrefService service) async {
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();
    String deviceToken = await FirebaseMessaging.instance.getToken();
    providerModel.deviceId = deviceToken;
    print("deviceId ${providerModel.deviceId}");
    print("fName ${providerModel.firstName}");
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
            'deviceToken': providerModel.deviceId
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
            'desc': profileModel.desc,
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
        'desc': profileModel.desc,
        'longitude': profileModel.longitude,
        'latitude': profileModel.latitude,
      });
      var response = await dio.post(
          'http://192.168.43.113:4000/addProvidersProfile',
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

  Future<List<ProfileModel>> getProvidersprofileData(
      DatabaseProvider provider) async {
    SharePrefService sharePrefService = SharePrefService();

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
      provider.list = profileList;
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
        String token = await FirebaseMessaging.instance.getToken();
        updateToken(token, currentUserId);
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
        .get(Uri.parse('http://192.168.43.113:4000/getProvidersProfile/${Id}'));
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
        .get(Uri.parse('http://192.168.43.113:4000/getTasksforProvider/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      // print(data);
      List<TasksModel> tasksList =
          data.map<TasksModel>((json) => TasksModel.fromJson(json)).toList();

      tasksProvider.tasksList = tasksList;
      return tasksList;
    }
  }

////////////////////////////////////////////////////////////only status
  Future<List<TaskModel1>> getTasksStatus(TasksProvider tasksProvider) async {
    String Id = await sharePrefService.getcurrentUserId();
    //  print(Id);
    final response = await http
        .get(Uri.parse('http://192.168.43.113:4000/getTasksforProvider/${Id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      // print(data);
      List<TaskModel1> tasksList = [];

      data.forEach((e) {
        TaskModel1 tasksModel = TaskModel1.onlyTaskStatus(
            e['offerStatus'], DateTime.tryParse(e['dateTime']));
        if (e['offerStatus'] == 'none') {
          //  print("yes");
          tasksList.add(tasksModel);
        }
      });

      tasksProvider.tasksListStatus = tasksList;
      //  print(tasksList.length);
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
        .get(Uri.parse('http://192.168.43.113:4000/getSingleTask/${offerId}'));
    if (response.statusCode == 200) {
      var data = TasksModel.fromJson(jsonDecode(response.body));
      tasksProvider.tasksModel = data;
    }
  }

  Future<String> giveRateReviewToUser(
      String taskId, double userRating, String userReview) async {
    //CustomToast.showToast(taskId);
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
    final response = await http.get(
        Uri.parse('http://192.168.43.113:4000/getCurrentProviderInfo/${id}'));
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
      userProfile.id = parsedData['_id'];
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

  Future<void> chatList(String userId, ChatProvider chatProvider) async {
    String providerId = await sharePrefService.getcurrentUserId();
    Chat chat = Chat();
    FirebaseFirestore.instance
        .collection('chats')
        .doc(userId + providerId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        chat.user_1 = documentSnapshot['user_1'];
        chat.user_2 = documentSnapshot['user_2'];
        chat.time = documentSnapshot['time'];
        chat.chats = (documentSnapshot['chats'] as List)
            .map((e) => ChatUser.fromJson(e))
            .toList();
        //  print(chat.chats);

      }
      chatProvider.twoWayChat = chat;
    });
    // print(chatProvider.twoWayChat );
  }

  Future<List<Chat>> inboxList(ChatProvider chatProvider) async {
    String userId = await sharePrefService.getcurrentUserId();
    List<Chat> chatList = [];
    await FirebaseFirestore.instance
        .collection('chats')
        .orderBy('time')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Chat chatModel = Chat.fromJson(doc.data());
        if (userId == doc['user_2']) {
          chatList.add(chatModel);
        }
      });
    });

    chatProvider.chatList = chatList;
    return chatList;
  }

  Future<String> snedMessage(ProviderModel providerModel, String userId,
      String userFname, String userLname, String message) async {
    String response = '';

    Timestamp time = Timestamp.now();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(userId + providerModel.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var list = [
          {
            'senderId': providerModel.id.toString(),
            'recieverId': userId.toString(),
            'message': message.toString(),
            'time': time
          }
        ];
        var docRef = FirebaseFirestore.instance
            .collection('chats')
            .doc(userId + providerModel.id);

        await docRef.update(
          {
            'time': time,
            'chats': FieldValue.arrayUnion(list),
          },
        ).then((value) {
          response = 'Data added';
        }).catchError((error) {
          response = 'error occured';
        });
      } else {
        var list = [
          {
            'senderId': providerModel.id.toString(),
            'recieverId': userId.toString(),
            'message': message.toString(),
            'time': time
          }
        ];
        var docRef = FirebaseFirestore.instance
            .collection('chats')
            .doc(userId + providerModel.id);

        await docRef.set(
          {
            'user_1': userId.toString(),
            'user_2': providerModel.id.toString(),
            'time': time,
            'chats': list,
            'userFirstName': userFname.toString(),
            'userLastName': userLname.toString(),
            'providerFirstName': providerModel.firstName.toString(),
            'providerLastName': providerModel.lastName.toString(),
          },
        ).then((value) {
          response = 'Data added';
        }).catchError((error) {
          response = 'error occured';
        });
      }
    });

    return response;
  }

  Future<List<ProvidersData>> getProviderProfileData(String id) async {
    final response = await http.get(Uri.parse(
        'http://192.168.43.113:4000/getServiceProviderProfile/${id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      //  print(data);
      List<ProvidersData> providerProfileList = data
          .map<ProvidersData>((json) => ProvidersData.fromJson(json))
          .toList();
      return providerProfileList;
    }
  }

  Future<String> deleteProviderProfile(String id) async {
    String res = '';
    final response = await http.get(
        Uri.parse('http://192.168.43.113:4000/deleteProviderProfile/${id}'));
    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      res = value['msg'];
    } else {
      var value = jsonDecode(response.body);
      res = value['msg'];
    }
    return res;
  }

  Future<String> updateProvidersProfile(
    ProgressDialog progressDialog,
    File image,
    String profileId,
    String shopName,
    String address,
    String des,
    String previousImageLink,
    String latitude,
    String longitude,
  ) async {
    String url = '';
    String res = '';
    progressDialog.style(
        progressWidget: RotationAnimation(20, 20),
        message: 'Please wait..',
        messageTextStyle: TextStyle(fontWeight: FontWeight.normal));
    progressDialog.show();

    //Uploading Image to Firebase
    if (image != null) {
      var storageReference =
          await FirebaseStorage.instance.refFromURL(previousImageLink);
      await storageReference.delete();

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
      url = await firebaseStorageRef.getDownloadURL();
      print(url);

      try {
        var response = await http.patch(
            Uri.parse('http://192.168.43.113:4000/updateDataImage'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'id': profileId,
              'shopImage': url,
              'shopName': shopName,
              'address': address,
              'desc': des,
              'longitude': longitude,
              'latitude': latitude,
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
      } catch (e) {
        print(e.toString());
        progressDialog.hide();
      }
    } else {
      try {
        var response =
            await http.patch(Uri.parse('http://192.168.43.113:4000/updateData'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({
                  'id': profileId,
                  'shopName': shopName,
                  'address': address,
                  'desc': des,
                  'longitude': longitude,
                  'latitude': latitude,
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
      } catch (e) {
        print(e.toString());
        progressDialog.hide();
      }
    }
    return res;
  }

  updateToken(String token, String userId) async {
    try {
      var response =
          await http.patch(Uri.parse('http://192.168.43.113:4000/updateToken'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                'id': userId,
                'deviceToken': token,
              }));
      if (response.statusCode == 200) {
        var value = jsonDecode(response.body);
        print('result is => ${value['msg']}');
      } else {
        var value = jsonDecode(response.body);
        print('result is => ${value['msg']}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendNotificationtoToToken(
      receiverToken, String screen, String body) async {
    var postUrl = "https://fcm.googleapis.com/fcm/send";
    final data = {
      "notification": {
        "body": body,
        "title": "ProviderLance",
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "screen": screen,
        'type': 'booking'
      },
      "to": "$receiverToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA_cd5TbM:APA91bHmbTNpi1fSANBEIqEw1UQ2pe5wMzlgKEqaq_7TqM4jxKURN-S12ErSxtFFjsIIajDbTPLUM88mP2rbiVyXCwQSLrhKws_bI9686ygCLq9SYvjKJ1I-z8Ehygxsd_fiKukG_ET1'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        print("sent");
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('exception $e');
    }
  }
}
