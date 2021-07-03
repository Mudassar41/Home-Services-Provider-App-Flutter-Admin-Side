import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/screens/bottomNavViews/homeView.dart';
import 'package:final_year_project/screens/bottomNavViews/tasksView.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/models/bottomNavItems.dart';
import 'package:final_year_project/screens/bottomNavViews/messagesView.dart';
import 'package:final_year_project/screens/bottomNavViews/profileSetting.dart';

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  List<BottomItems> bottomList = [
    BottomItems('Home', Icons.home_outlined),
    BottomItems('Inbox', Icons.mail_outline),
//    BottomItems('Bookings', Icons.task),
    // BottomItems('Settings', Icons.settings)
  ];
  int selectedIndex = 0;

  List<Widget> widgetsList = <Widget>[
    Home(),
    Inbox(),
  ];

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'ProviderLance',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_none_outlined))
        ],
      ),
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: widgetsList,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onItemTapped,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        elevation: 0.0,
        selectedItemColor: CustomColors.lightGreen,
        unselectedItemColor: Colors.grey,
        items: bottomList.map((e) {
          int index = bottomList.indexOf(e);
          return BottomNavigationBarItem(
              icon: Icon(e.iconData), label: e.title);
        }).toList(),
      ),
    ));
  }
}
