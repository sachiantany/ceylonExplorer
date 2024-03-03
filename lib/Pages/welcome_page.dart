import 'dart:core';

import 'package:ceylon_explorer/widgets/app_large_text.dart';
import 'package:ceylon_explorer/widgets/app_text.dart';
import 'package:ceylon_explorer/widgets/responsive_button.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'google_page.dart';
import '../misc/colors.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "welcome-one.png",
    "login-background.png",
    "welcome-three.png",
  ];
  List title = [
    "Discover Sri Lanka",
    "Connect with Guides",
    "Explore Endlessly"
  ];
  List tips = [
  "\"Uncover the hidden gems of Sri Lanka's vibrant history with our app, guiding you through ancient ruins, majestic temples, and storied landmarks that echo the country's rich cultural heritage.\"",
  "\"Forge connections with passionate guides, making every adventure unforgettable.Embark on a journey with trusted locals, sharing their love for Sri Lanka's hidden gems.\"",
  "\"Experience Sri Lanka with confidence as our live location tracking feature keeps you connected and secure throughout your adventures, allowing you to explore freely and discover the beauty of this tropical paradise.\""
];
  //List text=[ ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/" + images[index]),
                      fit: BoxFit.cover)),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Hint
                        AppLargeText(
                            text: "Hint", color: AppColors.bigTextColor),
                        //AppLargeText(text: "Discover", color:Colors.indigo),

                        //Tittles
                        AppText(
                            text: title[index],
                            size: 30,
                            color: AppColors.textColor1),
                        const SizedBox(
                          height: 20,
                        ),

                        //Text
                        SizedBox(
                          width: 300,
                          child: AppText(
                            text:tips[index],
                            color: AppColors.textColor2,
                            size: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        //Button
                        ResponsiveButton(
                          width: 120,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //Last Scroll Get Started Button
                        Center(
                          child: Column(
                            children: [
                              if (index == 2)
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppColors.textColor2,
                                        minimumSize: Size(300, 50),
                                      textStyle: TextStyle(fontSize: 20)
                                    ),
                                    child: const Text('Get Started'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 LoginPage()),
                                      );
                                    },
                                  ),

                                ),
                            ],
                          ),
                        )
                      ],
                    ),

                    //Animated 3 dots
                    Column(
                      children: List.generate(3, (indexDots) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          width: 8,
                          height: index == indexDots ? 25 : 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index == indexDots
                                  ? AppColors.mainColor
                                  : AppColors.mainColor.withOpacity(0.3)),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
