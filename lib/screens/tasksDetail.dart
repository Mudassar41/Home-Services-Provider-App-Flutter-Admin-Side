import 'package:final_year_project/models/tasksModel.dart';
import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/reusableComponents/customToast.dart';
import 'package:final_year_project/services/apiServices.dart';
import 'package:final_year_project/stateManagement/providers/tasksProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TasksDetail extends StatefulWidget {
  TasksModel tasksModel;

  TasksDetail({this.tasksModel});

  @override
  _TasksDetailState createState() => _TasksDetailState();
}

class _TasksDetailState extends State<TasksDetail> {
  ApiServices apiServices = ApiServices();
  TasksProvider tasksProvider;

  @override
  Widget build(BuildContext context) {
    tasksProvider = Provider.of<TasksProvider>(context);
    apiServices.getSingleTasks(widget.tasksModel.id, tasksProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Booking Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
        ),
        body: Consumer<TasksProvider>(builder: (context, items, _) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 20, left: 8, bottom: 8),
                                child: Icon(
                                  Icons.location_on,
                                  color: CustomColors.lightRed,
                                  size: 30,
                                ),
                              ),
                              Flexible(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'User Address',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(widget.tasksModel.userAdress),
                                    ]),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 20, left: 8, bottom: 8),
                                child: Icon(
                                  Icons.work,
                                  color: CustomColors.lightRed,
                                  size: 30,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Job Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(widget.tasksModel.providercategories
                                                .providerCatName ==
                                            null
                                        ? ""
                                        : '${widget.tasksModel.providercategories.providerCatName[0].toUpperCase()}${widget.tasksModel.providercategories.providerCatName.substring(1).toLowerCase()}'),
                                  ])
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 20, left: 8, bottom: 8),
                                child: Icon(
                                  Icons.label_important,
                                  color: CustomColors.lightRed,
                                  size: 30,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Budget',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(items.tasksModel.priceOffered == null
                                        ? ""
                                        : '${items.tasksModel.priceOffered} Rs'),
                                  ])
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 20, left: 8, bottom: 8),
                                child: Icon(
                                  Icons.timeline,
                                  color: CustomColors.lightRed,
                                  size: 30,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time Span',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(items.tasksModel.time == null
                                        ? ""
                                        : '${items.tasksModel.time} Hrs'),
                                  ])
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 20, left: 8, bottom: 8),
                                child: Icon(
                                  Icons.date_range_sharp,
                                  color: CustomColors.lightRed,
                                  size: 30,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(items.tasksModel.dateTime == null
                                        ? ""
                                        : '${items.tasksModel.dateTime.month}-${items.tasksModel.dateTime.day}-${items.tasksModel.dateTime.year}'),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items.tasksModel.des == null
                              ? ""
                              : items.tasksModel.des,
                        ),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Service Status",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )),
                  if (items.tasksModel.offerStatus == 'none')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Request in Process',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent),
                        maxLines: 2,
                      ),
                    )
                  else if (items.tasksModel.offerStatus == 'cancel')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cancelled',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.lightRed),
                      ),
                    )
                  else if (items.tasksModel.offerStatus == 'accepted')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'In Process',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent),
                      ),
                    )
                  else if (items.tasksModel.offerStatus == 'completed')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Completed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.lightGreen),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),
                  if (items.tasksModel.offerStatus == 'none')
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () async {
                              String res = await apiServices.updateTask(
                                  widget.tasksModel.id, 'accepted');
                            },
                            child: Container(
                              height: 40,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Accept offer',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: CustomColors.lightGreen,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 0,
                            child: Container(
                              width: 10,
                            )),
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 40,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Cancel offer',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: CustomColors.lightRed,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                            ),
                          ),
                        )
                      ],
                    )
                  else if (items.tasksModel.offerStatus == 'cancel')
                    Text('')
                  else if (items.tasksModel.offerStatus == 'accepted')
                    InkWell(
                      onTap: () {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Cancel Booking',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // height: 50,
                          decoration: BoxDecoration(
                              color: CustomColors.lightRed,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                      ),
                    )
                  else if (items.tasksModel.offerStatus == 'completed')
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'My Review',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        //condition for user review if no review nor rating
                        //if
                        items.tasksModel.providerReview == 'no' &&
                                items.tasksModel.providerRating <= 0.0
                            ? TextButton(
                                onPressed: () {
                                  // showMyDialog();
                                },
                                child: Text('Mark Review'))
                            //else
                            : items.tasksModel.providerRating <= 0.0
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : RatingBarIndicator(
                                    rating: items.tasksModel.providerRating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    direction: Axis.horizontal,
                                  ),
                        items.tasksModel.providerRating == null ||
                                items.tasksModel.providerReview == 'no'
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  items.tasksModel.providerReview,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                        /////////////////////////////////////////////////////////////
                        items.tasksModel.userReview != 'no' ||
                                items.tasksModel.userRating > 0.0
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'User Review',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),

                        items.tasksModel.userReview == 'no' &&
                                items.tasksModel.userRating <= 0.0
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            //else
                            : items.tasksModel.userRating <= 0.0
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : RatingBarIndicator(
                                    rating: items.tasksModel.userRating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    direction: Axis.horizontal,
                                  ),
                        items.tasksModel.userReview == null ||
                                items.tasksModel.userReview == 'no'
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  items.tasksModel.userReview,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                      ],
                    )
                ],
              ),
            ),
          );
        }));
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How was your experice?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    setState(() {
                      tasksProvider.rating = rating;
                    });
                  },
                ),
                Container(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: tasksProvider.reviewController,
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(
                        hintText: "Review about Service Provider",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.lightGreen),
                    ),
                    onPressed: () async {
                      String res = await apiServices.giveRateReviewToUser(
                          widget.tasksModel.id,
                          tasksProvider.rating,
                          tasksProvider.reviewController.text);
                      if (res == 'data updated') {
                        print("yes updated");
                        tasksProvider.rating = 0.0;
                        tasksProvider.reviewController.clear();
                        Navigator.of(context).pop();
                      } else {
                        CustomToast.showToast('Something went wrong');
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Close',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.lightRed)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
