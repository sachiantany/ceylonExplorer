import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Pages/login_page.dart';
import '../../Traveler/Navpages/home_page.dart';
import '../../misc/colors.dart';
import '../../widgets/app_large_text.dart';

class GuidePackage extends StatefulWidget {
  const GuidePackage({super.key});

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  get tabController => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GuidePackage"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),

    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
