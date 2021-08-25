import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/stateManagement/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingView extends StatelessWidget {
  // const ProfileSettingView({Key key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());
  SharePrefService sharedPreferences = SharePrefService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.lightGreen,
        onPressed: () {},
        child: Icon(Icons.edit_outlined),
      ),
      body: Obx(() {
        if (controller.isLoading.value == true) {
          return LoadingBar();
        } else {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  width: 150,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller.userInfo.value.imageLink,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 150,
                            width: 150,
                            // width: Screensize.widthMultiplier * 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: CustomColors.lightGreen, width: 2),
                              //  borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.error)),
                        ),
                        Positioned(
                            bottom: 0,
                            //   right: 0,
                            child: InkWell(
                              onTap: () {
                                controller.oldImageLink.value =
                                    controller.userInfo.value.imageLink;
                                controller.showImageSelectionDialog(context);
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                //    height: 20,
                                //   width: 20,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                child: Container(
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, right: 20, left: 8, bottom: 8),
                      child: Icon(
                        Icons.person_outline,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                        ),
                        Text(
                          '${controller.userInfo.value.firstName[0].toUpperCase()}${controller.userInfo.value.firstName.substring(1).toLowerCase()} ${controller.userInfo.value.lastName[0].toUpperCase()}${controller.userInfo.value.lastName.substring(1).toLowerCase()}  ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                child: Container(
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, right: 20, left: 8, bottom: 8),
                      child: Icon(
                        Icons.phone_android_outlined,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Conatct No',
                        ),
                        Text(
                          '0${controller.userInfo.value.phoneNumber.substring(3)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                child: Container(
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 60, left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: CustomColors.lightGreen,
                      minimumSize: Size(50, 50)),
                  child: Text('Log Out'),
                  onPressed: () {
                    sharedPreferences.updateBoolSp();
                    sharedPreferences.logOutCurrentuserSf();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
