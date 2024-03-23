import 'package:ceylon_explorer/Pages/login_page.dart';
import 'package:ceylon_explorer/Services/firestore.dart';
import 'package:ceylon_explorer/Traveler/Navpages/package_booking.dart';
import 'package:ceylon_explorer/misc/colors.dart';
import 'package:ceylon_explorer/widgets/app_large_text.dart';
import 'package:ceylon_explorer/widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.bigTextColor,
        backgroundColor: AppColors.buttonBackground2,
        onPressed: () {},
        child: const Icon(Icons.payment),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Menu Text
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      logout(context);
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                      color: AppColors.buttonBackground1,
                    ),
                  ),
                  // const Icon(Icons.menu, size: 30, color: AppColors.buttonBackground1),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.buttonBackground1.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //Select Your Journey
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: AppLargeText(
                text: "Select Your Journey",
                size: 30,
                color: AppColors.textColor1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            //TabpBar
            Container(
              child: Align(
                alignment: Alignment.centerLeft,

                //TabBar
                child: TabBar(
                    labelPadding: const EdgeInsets.only(left: 0, right: 40),
                    controller: tabController,
                    labelColor: AppColors.textColor2,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: CircleTabIndicator(
                        color: AppColors.mainColor, radius: 4),
                    tabs: const [
                      Tab(text: "Tours"),
                      Tab(text: "Activities"),
                      Tab(
                        text: "Custom Request",
                      )
                    ]),
              ),
            ),

            //Packages
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                height: double.maxFinite,
                width: double.maxFinite,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    PackageBooking(),
                    ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 15, top: 10),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 15, top: 10),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius);

    canvas.drawCircle(offset + circleOffset, radius, paint);
    // TODO: implement paint
  }
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
