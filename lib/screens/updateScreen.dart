import 'dart:io';
import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:final_year_project/models/providersData.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/customToast.dart';
import 'package:final_year_project/reusableComponents/formField.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UpdateProfileScreen extends StatefulWidget {
  final ProvidersData data;

  UpdateProfileScreen({this.data});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File image;
  final picker = ImagePicker();
  ProgressDialog progressDialog;
  Future location;
  String str = "Loading...";
  Position position;
  var lat;
  var lan;
  final formKey = GlobalKey<FormState>();
  ApiServices apiServices = ApiServices();
  var shopNameController;
  var addressController;
  var desController;
  ProviderProfilesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    shopNameController = TextEditingController(text: widget.data.shopName);
    addressController = TextEditingController(text: widget.data.address);
    desController = TextEditingController(text: widget.data.des);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Shop Image',
                    style: TextStyle(
                        fontSize: Sizing.textMultiplier * 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              image == null
                  ? IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showImageSelectionDialog(context);
                      })
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Stack(
                        children: [
                          Container(
                              clipBehavior: Clip.antiAlias,
                              height: 250,
                              // height: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                      image: FileImage(image),
                                      fit: BoxFit.cover))),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: CustomColors.lightRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                              ))
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Shop Name',
                    style: TextStyle(
                        fontSize: Sizing.textMultiplier * 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 8, bottom: 2),
                child: TextFormField(
                  //  initialValue: widget.data.shopName,
                  keyboardType: TextInputType.text,
                  controller: shopNameController,
                  textInputAction: TextInputAction.next,
                  decoration: FormFieldDesign.inputDecoration(
                      'Name', Icons.description_outlined),
                  onSaved: (name) {
                    //  profileModel.shopName = name;
                  },
                  validator: (name) {
                    if (name.isEmpty) {
                      return 'Field Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Address',
                    style: TextStyle(
                        fontSize: Sizing.textMultiplier * 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 8, bottom: 2),
                child: TextFormField(
                  //  initialValue: widget.data.address,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: addressController,
                  decoration:
                      FormFieldDesign.inputDecoration('Address', Icons.money),
                  onSaved: (address) {
                    //   profileModel.address = address;
                  },
                  validator: (address) {
                    if (address.isEmpty) {
                      return 'Field Requird';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontSize: Sizing.textMultiplier * 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 8, bottom: 2),
                child: TextFormField(
                  //  initialValue: widget.data.des,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: desController,
                  decoration: FormFieldDesign.inputDecoration(
                      'Description', Icons.description),
                  onSaved: (address) {
                    //   profileModel.desc = address;
                  },
                  validator: (address) {
                    if (address.isEmpty) {
                      return 'Field Requird';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: CustomColors.lightRed,
                        minimumSize: Size(200, 50)),
                    child: Text('Update Service'),
                    onPressed: () async {
                      if (!formKey.currentState.validate()) {
                        return;
                      } else {
                        formKey.currentState.save();
                        progressDialog.style(
                            progressWidget: RotationAnimation(20, 20),
                            message: 'Please wait getting Current Location',
                            messageTextStyle:
                                TextStyle(fontWeight: FontWeight.normal));
                        progressDialog.show();
                        position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                            forceAndroidLocationManager: true);

                        setState(() {
                          lat = position.latitude.toString();
                          lan = position.longitude.toString();
                        });
                        progressDialog.hide();
                        String res = await apiServices.updateProvidersProfile(
                            progressDialog,
                            image,
                            widget.data.id,
                            shopNameController.text,
                            addressController.text,
                            desController.text,
                            widget.data.shopImage,
                            lat,
                            lan);
                        if (res == 'data updated') {
                          controller.update();
                          Navigator.pop(context);
                        } else {
                          CustomToast.showToast('Error in Updation');
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getImageCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future getImageGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
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
}
