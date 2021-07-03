import 'dart:io';
import 'package:final_year_project/models/providerModel.dart';
import 'package:path/path.dart' as path;
import 'package:final_year_project/reusableComponents/customToast.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfileController extends GetxController {
  var userInfo = ProviderModel().obs;
  var isLoading = false.obs;
  ApiServices apiServices = ApiServices();
  SharePrefService sharePrefService = SharePrefService();
  File image;
  final picker = ImagePicker();
  var oldImageLink = ''.obs;

  Future<void> getCurrentUserInfo() async {
    isLoading(true);
    String Id = await sharePrefService.getcurrentUserId();
    print(Id);
    var userModel = await apiServices.getCurrrentUserInfo(Id);
    userInfo.value = userModel;

    isLoading(false);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUserInfo();
  }

  Future<void> showImageSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Select Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        getImageGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        getImageCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future getImageCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    //setState(() {
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    // });
    Navigator.of(context).pop();
    updateImage(image, oldImageLink.value);
  }

  Future getImageGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // setState(() {
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    //  });
    Navigator.of(context).pop();
    updateImage(image, oldImageLink.value);
  }

  updateImage(File image, String oldImageLink) async {
    CustomToast.showToast('please wait...');
    var file = FirebaseStorage.instance
        .ref()
        .child(oldImageLink)
        .getData()
        .then((value) async {
      var storageReference =
          await FirebaseStorage.instance.refFromURL(oldImageLink);
      await storageReference.delete();
      var fileExtension = path.extension(image.path);
      var uniqueId = Uuid().v4();
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'ServiceProviders/ProviderProfileImage$uniqueId$fileExtension');

      await firebaseStorageRef.putFile(image).then((result) {
        print('Uploaded');
      }).catchError((erorr) {
        print("Error in Uploading");
      });

      String url = await firebaseStorageRef.getDownloadURL();
      if (url != null) {
        print(url);
        apiServices.updateProfileImage(url, userInfo.value.id);
      }
    }).catchError((error) async {
      print('image not exist');
      var fileExtension = path.extension(image.path);
      var uniqueId = Uuid().v4();
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('ServiceProviders/userProfileImage$uniqueId$fileExtension');

      await firebaseStorageRef.putFile(image).then((result) {
        print('Uploaded');
      }).catchError((erorr) {
        print("Error in Uploading");
      });

      String url = await firebaseStorageRef.getDownloadURL();
      if (url != null) {
        print(url);
        apiServices.updateProfileImage(url, userInfo.value.id);
      }
    });
  }
}
