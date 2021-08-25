import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_year_project/models/profile.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/reusableComponents/textStyleForOrders.dart';
import 'package:final_year_project/screens/profileScreen.dart';
import 'package:final_year_project/screens/servicesDetail.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:final_year_project/stateManagement/providers/DbProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  ProviderProfilesController controller = Get.find();
  ApiServices apiServices = ApiServices();
  DatabaseProvider databaseProvider;
  SharePrefService sharePrefService = SharePrefService();

  @override
  Widget build(BuildContext context) {
    databaseProvider = Provider.of<DatabaseProvider>(context);
    apiServices.getProvidersprofileData(databaseProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String Id = await sharePrefService.getcurrentUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(currentUserId: Id)),
                );
              },
              icon: Icon(Icons.add))
        ],
        elevation: 0.0,
      ),
      body: Container(
        child: FutureBuilder(
          future: databaseProvider.getlist(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length == 0
                  ? Center(
                      child: Text(
                      'No Service Found. Add Service',
                      style: TextStyle(fontSize: 18),
                    ))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          // shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    controller.id.value =
                                        snapshot.data[index].id;
                                    controller.update();
                                    print(controller.id.value);
                                    Get.to(ServicesDetail());
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            width: 100,
                                            // height: 100,
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data[index].shopImage,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                // width: Screensize.widthMultiplier * 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Center(
                                                      child: Icon(Icons.error)),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data[index].shopName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                    snapshot
                                                        .data[index].address,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black54)),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          CustomColors.lightRed,
                                                      //   border: Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        '${snapshot.data[index].providercategories.providerCatName[0].toUpperCase()}${snapshot.data[index].providercategories.providerCatName.toLowerCase().substring(1)}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                    // height: 25,
                                                    // width: 70,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          }),
                    );
            }

            return LoadingBar();
          },
        ),
      ),
    );
  }
}
