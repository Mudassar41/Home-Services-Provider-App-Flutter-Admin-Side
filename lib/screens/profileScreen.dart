import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:final_year_project/animations/rotationAnimation.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:final_year_project/models/category.dart';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/formField.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/reusableComponents/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class ProfileScreen extends StatefulWidget {
  String currentUserId;

  ProfileScreen({
    Key key,
    this.currentUserId,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File image;
  final picker = ImagePicker();
  ApiServices apiServices = ApiServices();
  ProfileModel profileModel = ProfileModel();
  PageController pageController = PageController();
  FocusNode focusNode;
  bool value = true;
  bool setFloatIcon = true;
  ProgressDialog progressDialog;
  var lat;
  var lang;
  Position position;
  TextEditingController searchController = TextEditingController();
  dynamic selectedcategory;

  //ProviderProfilesController controller=Get.put(ProviderProfilesController());
  List<Categories> categoriesList = <Categories>[];
  List<Categories> tempList = <Categories>[];
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final TextEditingController pricePerDayController = TextEditingController();
  final TextEditingController pricePerHrsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  FirebaseAuth auth;
  dynamic currentUid;
  SharePrefService sharePrefService = SharePrefService();

  // Future location;
  String str = "Loading...";

  @override
  void initState() {
    super.initState();

    getFilterData();

    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.lightGreen,
          onPressed: () {
            if (pageController.page.toInt() == 0) {
              if (selectedcategory == null) {
                CustomSnackBar.showSnackBar('Please Select category', context);
              } else if (selectedcategory != null) {
                pageController.animateToPage(pageController.page.toInt() + 1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeIn);
                setState(() {
                  setFloatIcon = false;
                });
              }
            }
          },
          child: Icon(
              setFloatIcon == true ? Icons.arrow_forward : Icons.done_rounded)),
      body: PageView(
        controller: pageController,
        children: [category(), inputFields()],
      ),
    ));
  }

  Widget category() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text('Select Category',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Sizing.textMultiplier * 3)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          //shadowColor: Customcolors.green,
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            focusNode: focusNode,
            controller: searchController,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: value == true
                    ? IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            value = true;

                            categoriesList = tempList;
                          });
                          // categoriesController.searhtag.value='';
                          searchController.clear();
                          // categoriesController.onInit();
                        },
                      ),
                hintText: "Search Category",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            onChanged: (val) {
              setState(() {
                value = false;
              });
              filterList(val);
              print(val);
            },
          ),
        ),
      ),
      Expanded(
          child: isLoading == true
              ? LoadingBar()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: XSliverGridDelegate(
                      crossAxisCount: 2,
                      smallCellExtent: Sizing.heightMultiplier * 20,
                      bigCellExtent: Sizing.heightMultiplier * 20,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shadowColor: CustomColors.lightRed,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedcategory = categoriesList[index].id;
                              print(selectedcategory);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    CustomColors.lightGreen,
                                    Colors.white
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight),
                              color: Colors.black12,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.network(
                                        'http://192.168.43.113:4000/${categoriesList[index].imageLink}',
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '${categoriesList[index].name[0].toUpperCase()}${categoriesList[index].name.toLowerCase().substring(1)}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: selectedcategory ==
                                          categoriesList[index].id
                                      ? Icon(
                                          Icons.done_rounded,
                                          color: CustomColors.lightRed,
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: categoriesList.length,
                  ),
                )),
    ]);
  }

  Widget inputFields() {
    return SingleChildScrollView(
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
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 2),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: FormFieldDesign.inputDecoration(
                    'Name', Icons.description_outlined),
                onSaved: (name) {
                  profileModel.shopName = name;
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
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 2),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: addressController,
                decoration:
                    FormFieldDesign.inputDecoration('Address', Icons.money),
                onSaved: (address) {
                  profileModel.address = address;
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
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 2),
              child: TextFormField(
                maxLines: 5,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: descController,
                decoration: FormFieldDesign.inputDecoration(
                    'Description', Icons.description),
                onSaved: (address) {
                  profileModel.desc = address;
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
                  child: Text('Save Service'),
                  onPressed: () async {
                    //   currentUid=await sharePrefService.getcurrentUserIdFromSp();
                    if (!formKey.currentState.validate()) {
                      return;
                    } else {
                      formKey.currentState.save();
                      profileModel.catId = selectedcategory;
                      if (image != null) {
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
                          profileModel.latitude = position.latitude.toDouble();
                          profileModel.longitude =
                              position.longitude.toDouble();
                        });
                        progressDialog.hide();

                        String res = await apiServices.postPrvidersProfilesData(
                            profileModel,
                            progressDialog,
                            image,
                            widget.currentUserId);
                        if (res == 'Data Added') {
                          CustomSnackBar.showSnackBar(
                              'Profile Created', context);
                          // controller.update();
                          Get.back();
                        } else {
                          CustomSnackBar.showSnackBar(
                              'Something went wrong', context);
                        }
                      } else {
                        CustomSnackBar.showSnackBar(
                            'Please Pick Image', context);
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  filterList(String txt) {
    if (txt.isEmpty) {
      if (mounted)
        setState(() {
          categoriesList = tempList;
        });
    } else {
      final List<Categories> filteredBreeds = <Categories>[];
      tempList.map((breed) {
        if (breed.name.toLowerCase().contains(txt.toString().toLowerCase())) {
          filteredBreeds.add(breed);
        }
      }).toList();
      setState(() {
        categoriesList = filteredBreeds;
      });
    }
  }

  void getFilterData() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });
    tempList = [];
    final response =
        await http.get(Uri.parse('http://192.168.43.113:4000/getCats'));
    if (response.statusCode == 201) {
      var value = jsonDecode(response.body);
      var data = value['data'];
      data.forEach((data) {
        Categories categories = Categories(
            id: data['_id'],
            name: data['providerCatName'],
            imageLink: data['providerCatImage']);
        tempList.add(categories);
      });
    }
    if (mounted)
      setState(() {
        categoriesList = tempList;
        isLoading = false;
      });
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
