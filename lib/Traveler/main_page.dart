import 'package:ceylon_explorer/Traveler/Navpages/map_page.dart';
import 'package:ceylon_explorer/Traveler/Navpages/home_page.dart';
import 'package:ceylon_explorer/Traveler/Navpages/profile_page.dart';
import 'package:ceylon_explorer/Traveler/Navpages/package_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const PackagePage(),
    MapPage(),
    ProfilePage()
  ];
  int currentIndex = 0;
  void onTap(int index) {
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
          items: const [
            BottomNavigationBarItem(label: ("Home"), icon: Icon(Icons.apps)),
            BottomNavigationBarItem(
                label: ("Package"), icon: Icon(Icons.local_taxi)),
            BottomNavigationBarItem(
                label: ("Guide"), icon: Icon(Icons.location_on)),
            BottomNavigationBarItem(label: ("My"), icon: Icon(Icons.person_2)),
          ]),
    );
  }
}
