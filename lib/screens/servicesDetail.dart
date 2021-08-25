import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_year_project/models/providersData.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/customToast.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/screens/updateScreen.dart';
import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ServicesDetail extends StatelessWidget {
  ProviderProfilesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Detail"),
        elevation: 0.0,
      ),
      body: Obx(() {
        if (controller.isLoading == true) {
          return LoadingBar();
        } else {
          return ListView.builder(
              itemCount: controller.profileList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print(controller.profileList[index].shopImage);
                          },
                          child: CachedNetworkImage(
                            imageUrl: controller.profileList[index].shopImage,
                            imageBuilder: (context, imageProvider) => Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Shop Name',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Text(controller.profileList[index].shopName,
                                        textAlign: TextAlign.left,
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Text(controller.profileList[index].address,
                                        textAlign: TextAlign.left,
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Description',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  Text(controller.profileList[index].des,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '0${controller.profileList[index].serviceprovidersdatas.providerPhoneNumber.substring(3)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Jobs',
                                      style: TextStyle(color: Colors.black54)),
                                  Text(
                                    '${controller.profileList[index].offerscollections.length}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Rating',
                                      style: TextStyle(color: Colors.black54)),
                                  Text(
                                    (controller.profileList[index]
                                                    .offerscollections
                                                    .fold(
                                                        0,
                                                        (sum, element) =>
                                                            sum +
                                                            element
                                                                .userRating) /
                                                controller.profileList[index]
                                                    .offerscollections.length)
                                            .isNaN
                                        ? '0.0'
                                        : '${controller.profileList[index].offerscollections.fold(0, (sum, element) => sum + element.userRating) / controller.profileList[index].offerscollections.length}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Reviews',
                                      style: TextStyle(color: Colors.black54)),
                                  Text(
                                    getCount(controller.profileList[index])
                                                .toString() ==
                                            '0'
                                        ? "0"
                                        : getCount(
                                                controller.profileList[index])
                                            .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        controller.profileList[index].offerscollections.length <
                                0
                            ? Text('')
                            : Text(
                                "Reviews",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                            itemCount: controller
                                .profileList[index].offerscollections.length,
                            shrinkWrap: true,
                            itemBuilder: (context, ind) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      controller
                                                      .profileList[index]
                                                      .offerscollections[ind]
                                                      .userReview ==
                                                  'no' &&
                                              controller
                                                      .profileList[index]
                                                      .offerscollections[ind]
                                                      .userRating <=
                                                  0.0
                                          ? Container(
                                              height: 0,
                                              width: 0,
                                            )
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  controller
                                                      .profileList[index]
                                                      .offerscollections[ind]
                                                      .usersregistrationprofiles
                                                      .userImage),
                                            ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' ${controller.profileList[index].offerscollections[ind].usersregistrationprofiles.firstName[0].toUpperCase()}${controller.profileList[index].offerscollections[ind].usersregistrationprofiles.firstName.toLowerCase().substring(1)} ${controller.profileList[index].offerscollections[ind].usersregistrationprofiles.lastName[0].toUpperCase()}${controller.profileList[index].offerscollections[ind].usersregistrationprofiles.lastName.toLowerCase().substring(1)}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black45),
                                            ),
                                            controller
                                                        .profileList[index]
                                                        .offerscollections[ind]
                                                        .userRating <=
                                                    0.0
                                                ? Container(
                                                    height: 0,
                                                    width: 0,
                                                  )
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      RatingBarIndicator(
                                                        rating: controller
                                                            .profileList[index]
                                                            .offerscollections[
                                                                ind]
                                                            .userRating,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 20.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '  ${controller.profileList[index].offerscollections[ind].userRating}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2),
                                              child: controller
                                                          .profileList[index]
                                                          .offerscollections[
                                                              ind]
                                                          .userReview ==
                                                      'no'
                                                  ? Container(
                                                      height: 8,
                                                      width: 0,
                                                    )
                                                  : Text(
                                                      controller
                                                          .profileList[index]
                                                          .offerscollections[
                                                              ind]
                                                          .userReview,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: CustomColors.lightGreen),
                                      onPressed: () async {
                                        String res = await controller
                                            .apiServices
                                            .deleteProviderProfile(controller
                                                .profileList[index].id);
                                        if (res == 'Data Deleted') {
                                          Get.back();
                                        } else {
                                          CustomToast.showToast(
                                              'Profile not deleted');
                                        }
                                      },
                                      child: Text("Delete Profile")),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: CustomColors.lightRed),
                                      onPressed: () {
                                        // controller.apiServices
                                        //     .getProviderProfileData(controller
                                        //         .profileList[index].id);
                                        // controller.refresh();
                                        Get.to(UpdateProfileScreen(
                                            data:
                                                controller.profileList[index]));
                                      },
                                      child: Text("Update Profile")),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      }),
    );
  }

  int getCount(ProvidersData profileList) {
    int reviewCount = 0;
    for (int i = 0; i < profileList.offerscollections.length; i++) {
      if (profileList.offerscollections[i].userReview != 'no') {
        reviewCount++;
        print("yes");
      }
    }
    return reviewCount;
  }
}
