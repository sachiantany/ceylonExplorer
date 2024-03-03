import 'package:ceylon_explorer/Pages/login_page.dart';
import 'package:ceylon_explorer/Traveler/Navpages/package_page.dart';
import 'package:ceylon_explorer/misc/colors.dart';
import 'package:ceylon_explorer/widgets/app_large_text.dart';
import 'package:ceylon_explorer/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var images = {
    "balloning.png": "Balloning",
    "hiking.png": "Hiking",
    "kayaking.png": "Kayaking",
    "snorkeling.png": "Snorkeling",
    "surfing.png": "Surfing",
    "diving.png": "Diving"
  };

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
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

            //Discover Text
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: AppLargeText(
                text: "Discover",
                size: 40,
                color: AppColors.textColor1,
              ),
            ),
            const SizedBox(
              height: 10,
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
                      Tab(text: "Places"),
                      Tab(text: "Beaches"),
                      Tab(text: "Mountains"),
                    ]),
              ),
            ),

            //Places
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 320,
              width: double.maxFinite,
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 15, top: 10),
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            image: const DecorationImage(
                                image: AssetImage("img/tower.png"),
                                fit: BoxFit.cover)),
                      );
                    },
                  ),
                  const Text("There"),
                  const Text("bye")
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //Explorer More
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(
                      text: "Explore more",
                      size: 25,
                      color: AppColors.textColor1),
                  AppText(
                    text: "See All",
                    color: AppColors.textColor2,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //Activities
            Container(
              height: 130,
              width: double.maxFinite,
              margin: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          Container(
                            // margin: const EdgeInsets.only(right: 50),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.buttonBackground3,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "img/" + images.keys.elementAt(index)),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: AppText(
                              text: images.values.elementAt(index),
                              color: AppColors.textColor2,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),

            // IconButton(
            //   icon: Icon(Icons.camera),
            //   iconSize: 50,
            //   color: Colors.black,
            //   onPressed: () {},
            // ),

            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 0.0,
                    height: 80,
                    minWidth: 380,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagePage()));
                    },
                    child: Text(
                      "Let's Find Your Journey Plan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    color: AppColors.buttonBackground2,
                  ),
                ],
              ),
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
