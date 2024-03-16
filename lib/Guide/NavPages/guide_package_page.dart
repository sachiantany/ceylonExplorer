import 'dart:io';

import 'package:ceylon_explorer/Services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Pages/login_page.dart';
import '../../Traveler/Navpages/home_page.dart';
import '../../misc/colors.dart';
import '../../widgets/app_large_text.dart';

import 'package:latlong2/latlong.dart' as latLng;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GuidePackage extends StatefulWidget {
  const GuidePackage({super.key});

  @override
  State<GuidePackage> createState() => _GuidePackageState();
}

class _GuidePackageState extends State<GuidePackage> {
  get tabController => null;

  final FirestoreServices firestoreServices = FirestoreServices();

  final TextEditingController textController = TextEditingController();

  final TextEditingController packageNameController = TextEditingController();
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final TextEditingController tTypeController = TextEditingController();
  final TextEditingController vTypeController = TextEditingController();
  final TextEditingController tCountController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  List<String> list = <String>[
    'Historical And Cultural',
    'Entertaining And Sports',
    'Beaches',
    'Natural Attraction'
  ];

  List<String> listVType = <String>['Bus', 'Van', 'Motor Car', 'Tuk Tuk'];

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

  LatLng _selectedLocation = LatLng(7.094049, 80.022771);

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(7.094049, 80.022771),
    zoom: 11.5,
  );

  // To store the selected location
  final Set<Marker> markers = {};

  String? imageURL = '';
  XFile? imageFile;

  // Callback function to handle tap on the map
  // void _onMapTapped(LatLng latLng) {
  //   setState(() {
  //     _selectedLocation = latLng; // Update selected location
  //     positionController.text = latLng.toString();

  //     markers.removeWhere((marker) => marker.markerId.value == 'marker1');
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId('marker1'),
  //         position: latLng,
  //         draggable: true,
  //         onDragEnd: (newPosition) {
  //           // Handle drag end event if needed
  //         },
  //       ),
  //     );
  //   });
  // }

  void openNoteBox({String? docID}) {
    String? dropdownValue;
    String? vTypeValue;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Tour Plan",
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 2.0),
                    ),
                    _buildTextField("Tour Title", packageNameController),
                    _buildTextField("Tour Description", placeNameController),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return GoogleMap(
                              mapToolbarEnabled: true,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              initialCameraPosition: CameraPosition(
                                  target: _selectedLocation, zoom: 11.5),
                              onTap: (latlang) {
                                // _onMapTapped(latlang);
                                LatLng latLng =
                                    LatLng(latlang.latitude, latlang.longitude);
                                setState(() {
                                  _selectedLocation =
                                      latLng; // Update selected location
                                  positionController.text = latLng.toString();

                                  markers.removeWhere((marker) =>
                                      marker.markerId.value == 'marker1');
                                  markers.add(
                                    Marker(
                                      markerId: MarkerId('marker1'),
                                      position: latLng,
                                      draggable: true,
                                      onDragEnd: (newPosition) {},
                                    ),
                                  );
                                });
                              },
                              markers: markers);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        enabled: false,
                        controller: positionController,
                        decoration: InputDecoration(
                          labelText: "Location ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // _buildTextField("Tour Type", tTypeController),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StatefulBuilder(builder: (context, setState) {
                        return Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                4.0), // Adjust the border radius as needed
                            border: Border.all(
                                color: Colors.black54), // Add border color
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Tour Type ',
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            value: dropdownValue,
                            // icon: const Icon(Icons.arrow_downward),
                            // elevation: 16,
                            underline: SizedBox(),
                            onChanged: (value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value.toString();
                                tTypeController.text = value!;
                              });
                            },

                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                    ),
                    _buildTextField("Price (Rs.)", priceController),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StatefulBuilder(builder: (context, setState) {
                        return Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                4.0), // Adjust the border radius as needed
                            border: Border.all(
                                color: Colors.black54), // Add border color
                          ),
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select Vehicle Type ',
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            value: vTypeValue,
                            // icon: const Icon(Icons.arrow_downward),
                            // elevation: 16,
                            underline: SizedBox(),
                            onChanged: (value) {
                              // This is called when the user selects an item.
                              setState(() {
                                vTypeValue = value.toString();
                                vTypeController.text = value!;
                              });
                            },

                            items: listVType
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                    ),

                    _buildTextField("Travelers Count", tCountController),
                    // _buildTextField("Photos", imageController),
                    // Stack(
                    //   alignment: AlignmentDirectional.topEnd,
                    //   children: [
                    //     Image.network(
                    //       "https://firebasestorage.googleapis.com/v0/b/flutter-firebase-crud-7bd52.appspot.com/o/Screenshot%202024-03-08%20at%2014.08.02.png?alt=media&token=279f5748-88bd-40da-ba7b-1f1b934a0a52",
                    //       width: 300,
                    //       height: 200,
                    //       fit: BoxFit.cover,
                    //     ),
                    //     IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           imageFile = null;
                    //           imageController.clear(); // Clear the text field
                    //         });
                    //       },
                    //       icon: Icon(Icons.delete),
                    //       color: Colors.black,
                    //     ),
                    //   ],
                    // ),
                    StatefulBuilder(builder: (context, setState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: 300,
                        // height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              4.0), // Adjust the border radius as needed
                          border: Border.all(
                              color: Colors.black54), // Add border color
                        ),
                        child: imageFile != null
                            ? Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Image.file(
                                    File(imageFile!.path),
                                    width: 300,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        imageFile = null;
                                        imageController
                                            .clear(); // Clear the text field
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            : IconButton(
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                  );

                                  print('${file?.path}');

                                  if (file == null) return;
                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();

                                  //Get a reference to storage root
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();

                                  Reference referenceDirImages =
                                      referenceRoot.child('images');

                                  //Create a reference for the image to be
                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);

                                  // setState(() {
                                  //   imageFile = file;
                                  //   this.imageURL = imageURL;
                                  // });
                                  try {
                                    //Store the file
                                    await referenceImageToUpload
                                        .putFile(File(file.path));
                                    String imageURL =
                                        await referenceImageToUpload
                                            .getDownloadURL();

                                    setState(() {
                                      imageFile = file;
                                      imageController.text = imageURL;
                                      this.imageURL = imageURL;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                icon: Icon(Icons.photo_album),
                              ),
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreServices.addPackage(
                            packageNameController.text,
                            tTypeController.text,
                            placeNameController.text,
                            positionController.text,
                            priceController.text,
                            vTypeController.text,
                            tCountController.text,
                            imageController.text);
                      } else {
                        firestoreServices.updatePackage(
                            docID,
                            packageNameController.text,
                            tTypeController.text,
                            placeNameController.text,
                            positionController.text,
                            priceController.text,
                            vTypeController.text,
                            tCountController.text,
                            imageController.text);
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.bigTextColor,
        backgroundColor: AppColors.buttonBackground2,
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreServices.getPackageStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List noteList = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    //get each individual doc
                    DocumentSnapshot documentSnapshot = noteList[index];
                    String docID = documentSnapshot.id;

                    //get note from each node
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String packageName = data['packageName'];
                    String packageId = data['packageId'];
                    String packagePrice = data['price'];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(packageId),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Package: " + packageName),
                              Text("Price: " + packagePrice),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => openNoteBox(docID: docID),
                                icon: Icon(Icons.settings),
                              ),
                              IconButton(
                                onPressed: () {
                                  firestoreServices.deletePackage(docID);
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
