import 'package:final_year_project/reusableComponents/customColors.dart';
import 'package:final_year_project/screens/bottomNavViews/homeView.dart';
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
    BottomItems('Home', Icons.home_filled),
    BottomItems('Inbox', Icons.mail),
    BottomItems('Settings', Icons.settings)
  ];
  int selectedIndex = 0;

  List<Widget> widgetsList = <Widget>[Home(), Inbox(), ProfileSetting()];

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
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: widgetsList,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
