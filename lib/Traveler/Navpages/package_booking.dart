import 'package:ceylon_explorer/Services/firestore.dart';
import 'package:ceylon_explorer/Traveler/Navpages/order_page.dart';
import 'package:ceylon_explorer/Traveler/Navpages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/widgets.dart';

class PackageBooking extends StatefulWidget {
  const PackageBooking({super.key});

  @override
  State<PackageBooking> createState() => _PackageBookingState();
}

class _PackageBookingState extends State<PackageBooking> {
  final FirestoreServices firestoreServices = FirestoreServices();

  final TextEditingController packageNameController = TextEditingController();
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final TextEditingController tTypeController = TextEditingController();
  final TextEditingController vTypeController = TextEditingController();
  final TextEditingController tCountController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final TextEditingController tripDateController = TextEditingController();

  late DateTime selectedTripDateTime;

  @override
  void initState() {
    selectedTripDateTime = DateTime.now();
  }

  final Set<Marker> markers = {};
  LatLng _selectedLocation = LatLng(0, 0);

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

  getInitialData() async {
    _selectedLocation = LatLng(7.094049, 80.022771);
    setMarker(_selectedLocation);
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(7.094049, 80.022771),
    zoom: 11.5,
  );

  setMarker(LatLng latLng) async {
    markers.removeWhere((marker) => marker.markerId.value == 'marker1');
    markers.add(
      Marker(
        markerId: MarkerId('marker1'),
        position: latLng,
        draggable: true,
        onDragEnd: (newPosition) {},
      ),
    );
  }

  void _clearControllers() {
    packageNameController.clear();
    placeNameController.clear();
    positionController.clear();
    priceController.clear();
    tTypeController.clear();
    vTypeController.clear();
    tCountController.clear();
  }

  GeoPoint geoPoint = GeoPoint(0, 0);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedTripDateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedTripDateTime) {
      setState(() {
        selectedTripDateTime = picked;
        tripDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void openOrderForm(
      {String? docID,
      String? tourGuiderId,
      String? tourType,
      String? placeName,
      String? packagePrice}) {
    getInitialData();

    setState(() {
      placeNameController.text = placeName!;
      priceController.text = packagePrice!;
    });
    if (docID == null) _clearControllers();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Oder Details",
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 2.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        enabled: false,
                        controller: placeNameController,
                        decoration: InputDecoration(
                          labelText: "Place Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: TextField(
                                enabled: false,
                                controller: tripDateController,
                                decoration: InputDecoration(
                                  labelText: "Trip Date",
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                                onTap: (LatLng latlang) {
                                  LatLng latLng = LatLng(
                                      latlang.latitude, latlang.longitude);
                                  setState(() {
                                    _selectedLocation = latLng;

                                    double latitude = latlang.latitude;
                                    double longitude = latlang.longitude;

                                    // Create a GeoPoint object
                                    geoPoint = GeoPoint(latitude, longitude);
                                    positionController.text = latLng.toString();

                                    setMarker(_selectedLocation);
                                  });
                                },
                                markers: markers);
                          },
                        ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        enabled: false,
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: "Price ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    _buildTextField("Travelers Count", tCountController),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      firestoreServices.createOrder(
                          docID!,
                          tourGuiderId!,
                          tourType!,
                          placeName!,
                          geoPoint,
                          selectedTripDateTime,
                          packagePrice!,
                          tCountController.text,
                          "Processing");

                      _clearControllers();

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderPage()),
                      );
                    },
                    child: Text("Request"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
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
                        String tourGuiderId = data['addedBy'];
                        String packagePrice = data['price'];
                        String placeImage = data['images'];

                        String placeName = data['placeName'];
                        String tourType = data['tourType'];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: SizedBox(
                                width: 60,
                                height: 60,
                                child: Image(
                                  image: NetworkImage(placeImage),
                                ),
                              ),
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
                                  ElevatedButton(
                                    child: Text("Book Now"),
                                    onPressed: () {
                                      openOrderForm(
                                          docID: docID,
                                          tourGuiderId: tourGuiderId,
                                          tourType: tourType,
                                          placeName: placeName,
                                          packagePrice: packagePrice);
                                    },
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            ),
                          ],
                        );
                      });
                } else {
                  return Text("No Packages...");
                }
              }),
        ),
      ],
    ));
  }
}
