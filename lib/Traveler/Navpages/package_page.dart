import 'package:ceylon_explorer/Pages/login_page.dart';
import 'package:ceylon_explorer/Services/firestore.dart';
import 'package:ceylon_explorer/misc/colors.dart';
import 'package:ceylon_explorer/widgets/app_large_text.dart';
import 'package:ceylon_explorer/widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage>
    with TickerProviderStateMixin {
  final FirestoreServices firestoreServices = FirestoreServices();

  final TextEditingController textController = TextEditingController();

  final TextEditingController packageNameController = TextEditingController();
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _clearControllers() {
    packageNameController.clear();
    placeNameController.clear();
    positionController.clear();
    priceController.clear();
  }

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField("Package Name", packageNameController),
                    _buildTextField("Place Name", placeNameController),
                    _buildTextField("Position", positionController),
                    _buildTextField("Price", priceController),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreServices.addPackage(
                            packageNameController.text,
                            placeNameController.text,
                            positionController.text,
                            priceController.text);
                      } else {
                        firestoreServices.updatePackage(
                            docID,
                            packageNameController.text,
                            placeNameController.text,
                            positionController.text,
                            priceController.text);
                      }

                      _clearControllers();

                      Navigator.pop(context);
                    },
                    child: Text(docID == null ? "Add" : "Update"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.bigTextColor,
        backgroundColor: AppColors.buttonBackground2,
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
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
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: double.maxFinite,
              width: double.maxFinite,
              child: TabBarView(
                controller: tabController,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: firestoreServices.getPackageStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List noteList = snapshot.data!.docs;

                          return ListView.builder(
                              itemCount: noteList.length,
                              itemBuilder: (context, index) {
                                //get each individual doc
                                DocumentSnapshot documentSnapshot =
                                    noteList[index];
                                String docID = documentSnapshot.id;

                                //get note from each node
                                Map<String, dynamic> data = documentSnapshot
                                    .data() as Map<String, dynamic>;
                                String packageName = data['packageName'];
                                String packageId = data['packageId'];
                                String packagePrice = data['price'];

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text(packageId),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Package: " + packageName),
                                          Text("Price: " + packagePrice),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                openNoteBox(docID: docID),
                                            icon: Icon(Icons.settings),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              firestoreServices
                                                  .deletePackage(docID);
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      // Add a Divider between ListTiles
                                      color: Colors.grey,
                                      thickness: 1.0,
                                    ),
                                  ],
                                );
                              });
                        } else {
                          return Text("No Packages...");
                        }
                        // return ListView.builder(
                        //   itemCount: 10,
                        //   scrollDirection: Axis.vertical,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Container(
                        //       margin: const EdgeInsets.only(right: 15, top: 10),
                        //       width: 200,
                        //       height: 100,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20),
                        //         color: Colors.grey,
                        //       ),
                        //     );
                        //   },
                        // );
                      }),
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
