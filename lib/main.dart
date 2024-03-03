import 'package:ceylon_explorer/Pages/login_page.dart';
import 'package:ceylon_explorer/Traveler/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Traveler/detail_page.dart';
import 'Pages/welcome_page.dart';
import 'Pages/google_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ), //ThemeData
      home:    MainPage(),
    );
  }
}
