import 'dart:ui';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:final_year_project/reusableComponents/textStyleForOrders.dart';
import 'package:final_year_project/screens/bottomNavViews/profileSetting.dart';
import 'package:final_year_project/screens/bottomNavViews/tasksView.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/stateManagement/controllers/profilesController.dart';
import 'package:final_year_project/stateManagement/providers/DbProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/services/sharedPrefService.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../servicesScreen.dart';

class Home extends StatelessWidget {
  SharePrefService sharePrefService = SharePrefService();
  ApiServices apiServices = ApiServices();
  final controller = Get.put(ProviderProfilesController());
  DatabaseProvider databaseProvider;

  @override
  Widget build(BuildContext context) {
    databaseProvider = Provider.of<DatabaseProvider>(context);
    apiServices.getProvidersprofileData(databaseProvider);
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Service Provider Admin Dashboard',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.lightGreen,
                      fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 200,
                        child: Card(
                          elevation: 3.0,
                          child: InkWell(
                            onTap: () {
                              Get.to(ServicesScreen());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/settings.svg',
                                    height: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Services Offered",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 200,
                        child: Card(
                          elevation: 3.0,
                          child: InkWell(
                            onTap: () {
                              Get.to(TasksView());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/suitcase.svg',
                                    height: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Bookings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 200,
                        child: Card(
                          elevation: 3.0,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/checklist.svg',
                                    height: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Orders History",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 200,
                        child: Card(
                          elevation: 3.0,
                          child: InkWell(
                            onTap: () {
                              Get.to(ProfileSettingView());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/man.svg',
                                    height: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Profile Setting",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )
            // Stack(children: [
            //   Container(
            //     height: Sizing.heightMultiplier * 14,
            //     color: CustomColors.lightGreen,
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //           top: Sizing.heightMultiplier * 3,
            //           left: Sizing.heightMultiplier + 10,
            //           right: Sizing.heightMultiplier + 10,
            //           bottom: Sizing.heightMultiplier),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Flexible(
            //               child: Text(
            //             'Mudassar Maqbool',
            //             style: TextStyle(
            //                 color: Colors.white, fontWeight: FontWeight.bold),
            //           )),
            //           Stack(
            //             children: [
            //               Icon(
            //                 Icons.circle_notifications,
            //                 color: Colors.white,
            //                 size: 30,
            //               ),
            //               Positioned(
            //                 right: 0,
            //                 child: Container(
            //                   height: 10,
            //                   width: 10,
            //                   decoration: BoxDecoration(
            //                       color: CustomColors.lightRed,
            //                       shape: BoxShape.circle),
            //                 ),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            //   Padding(
            //     padding: EdgeInsets.only(
            //         top: Sizing.heightMultiplier * 10,
            //         right: Sizing.heightMultiplier + 5,
            //         left: Sizing.heightMultiplier + 5),
            //     child: Card(
            //         clipBehavior: Clip.antiAlias,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //         elevation: 5,
            //         child: Container(
            //             height: Sizing.heightMultiplier * 14,
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Column(
            //                 children: [
            //                   Text(
            //                     'Overall Statistics',
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18,
            //                         color: Colors.grey),
            //                   ),
            //                   SizedBox(
            //                     height: 6,
            //                   ),
            //                   Row(
            //                     children: [
            //                       Expanded(
            //                         flex: 1,
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                           children: [
            //                             Text(
            //                               '4.2',
            //                               style:
            //                                   OrdersTextStyle.statisticsStyle(),
            //                             ),
            //                             Text(
            //                               'Ratings',
            //                               style: OrdersTextStyle
            //                                   .statisticsyTextStyle(),
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                           children: [
            //                             Text('3',
            //                                 style: OrdersTextStyle
            //                                     .statisticsStyle()),
            //                             Text(
            //                               'Reviews',
            //                               style: OrdersTextStyle
            //                                   .statisticsyTextStyle(),
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                           children: [
            //                             Text('4',
            //                                 style: OrdersTextStyle
            //                                     .statisticsStyle()),
            //                             Text(
            //                               'Orders',
            //                               style: OrdersTextStyle
            //                                   .statisticsyTextStyle(),
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ))),
            //   ),
            //   Padding(
            //     padding: EdgeInsets.only(
            //         top: Sizing.heightMultiplier * 25,
            //         right: Sizing.heightMultiplier + 5,
            //         left: Sizing.heightMultiplier + 5),
            //     child: Card(
            //         clipBehavior: Clip.antiAlias,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //         elevation: 5,
            //         child: Container(
            //             height: Sizing.heightMultiplier * 28,
            //             width: MediaQuery.of(context).size.width,
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     'Orders History',
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 18,
            //                         color: Colors.grey),
            //                   ),
            //                   //   Container(height: 1,color: Colors.grey,),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Active',
            //                             style: OrdersTextStyle.ordersStyle()),
            //                         Text('0',
            //                             style:
            //                                 OrdersTextStyle.statisticsStyle())
            //                       ],
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Completed',
            //                             style: OrdersTextStyle.ordersStyle()),
            //                         Text('2',
            //                             style:
            //                                 OrdersTextStyle.statisticsStyle())
            //                       ],
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Cancelled',
            //                             style: OrdersTextStyle.ordersStyle()),
            //                         Text('1',
            //                             style:
            //                                 OrdersTextStyle.statisticsStyle())
            //                       ],
            //                     ),
            //                   ),
            //                   ElevatedButton(
            //                       style: ElevatedButton.styleFrom(
            //                           shape: RoundedRectangleBorder(
            //                               borderRadius: BorderRadius.all(
            //                                   Radius.circular(5.0))),
            //                           minimumSize: Size(70, 40),
            //                           primary: CustomColors.lightRed),
            //                       onPressed: () {
            //                         sharePrefService.updateBoolSp();
            //                         sharePrefService.logOutCurrentuserSf();
            //                       },
            //                       child: Text('View Details'))
            //                 ],
            //               ),
            //             ))),
            //   )
            // ]),
            // Padding(
            //   padding: EdgeInsets.only(
            //       right: Sizing.heightMultiplier + 5,
            //       left: Sizing.heightMultiplier + 5),
            //   child: Card(
            //     clipBehavior: Clip.antiAlias,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //     elevation: 5,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               'Services Offered',
            //               style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 18,
            //                   color: Colors.grey),
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text('Active Services',
            //                     style: OrdersTextStyle.ordersStyle()),
            //                 Flexible(child: Consumer<DatabaseProvider>(
            //                     builder: (context, items, _) {
            //                   if (items.list.isEmpty) {
            //                     return CupertinoActivityIndicator();
            //                   } else {
            //                     return Text('${items.list.length}');
            //                   }
            //                 }))
            //               ],
            //             ),
            //           ),
            //           ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius:
            //                           BorderRadius.all(Radius.circular(5.0))),
            //                   minimumSize: Size(70, 40),
            //                   primary: CustomColors.lightRed),
            //               onPressed: () async {
            //                 String Id =
            //                     await sharePrefService.getcurrentUserId();
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => ServicesScreen()),
            //                 );
            //               },
            //               child: Text('View Details')),
            //
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
