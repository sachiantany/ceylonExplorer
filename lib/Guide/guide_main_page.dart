import 'package:ceylon_explorer/Guide/NavPages/guide.notification.dart';
import 'package:ceylon_explorer/Guide/NavPages/guide_package_page.dart';
import 'package:ceylon_explorer/Guide/NavPages/guide_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Pages/login_page.dart';
import '../Pages/login_page.dart';

class TourGuide extends StatefulWidget {
  const TourGuide({Key? key}) : super(key: key);

  @override
  _TourGuideState createState() => _TourGuideState();
}

class _TourGuideState extends State<TourGuide> {
  List pages = [
    const GuidePackage(),
    const GuideNotifi(),
    const GuideProfile(),

  ];
  int currentIndex=0;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 0,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items:const [
            BottomNavigationBarItem(label:("Home"),icon: Icon(Icons.apps)),
            BottomNavigationBarItem(label:("Package"),icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(label:("Guide"),icon: Icon(Icons.person_2)),
          ]
      ),
    );
  }
}
