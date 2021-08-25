import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/lodingbar.dart';
import 'package:final_year_project/screens/bottomNavViews/tasksView.dart';
import 'package:final_year_project/screens/tasksDetail.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/stateManagement/providers/tasksProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TasksProvider tasksProvider;
  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tasksProvider = Provider.of<TasksProvider>(context);
    apiServices.getTasksStatus(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: Consumer<TasksProvider>(
        builder: (context, items, _) {
          if (items.tasksStatus.length == null) {
            return Center(child: LoadingBar());
          } else {
            return items.tasksStatus.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/no.svg',
                          width: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No Notifications',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.lightRed),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      double radius;
                      return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: InkWell(
                              onTap: () {
                                Get.to(TasksView());
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.book_online_outlined,
                                                color: CustomColors.lightRed,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'New Booking Request',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                '${items.tasksStatus[index].dateTime.month}-${items.tasksStatus[index].dateTime.day}-${items.tasksStatus[index].dateTime.year}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))));
                    },
                    itemCount: items.tasksStatus.length,
                  );
          }
        },
      ),
    );
  }
}
