import 'package:ceylon_explorer/Services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final FirestoreServices firestoreServices = FirestoreServices();

  String? currentUser;

  @override
  void initState() {
    super.initState();
    User? creator = FirebaseAuth.instance.currentUser;
    // Future<DocumentSnapshot?> documentSnapshot =
    //     firestoreServices.getUserById(creator!.uid);

    setState(() {
      currentUser = creator!.uid;
      print("333333 $currentUser");
    });
  }

  Future<String?> getGuider(docId) async {
    DocumentSnapshot<Object?>? documentSnapshot =
        await firestoreServices.getUserById(docId);
    if (documentSnapshot != null) {
      var name = documentSnapshot['name'];
      return name;
    } else {
      print('Document not found or error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 600,
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreServices.setOrderById(currentUser),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List noteList = snapshot.data!.docs;
                    print("countttt ${noteList.length}");
                    return ListView.builder(
                        itemCount: noteList.length,
                        itemBuilder: (context, index) {
                          //get each individual doc
                          DocumentSnapshot documentSnapshot = noteList[index];
                          String docID = documentSnapshot.id;

                          //get note from each node
                          Map<String, dynamic> data =
                              documentSnapshot.data() as Map<String, dynamic>;
                          String packageName = data['placeName'];
                          String packageId = data['packageId'];
                          Timestamp tripDate = data['tripDate'];
                          String packagePrice = data['amount'];

                          String placeName = data['placeName'];
                          String tourType = data['tourType'];
                          String orderStatus = data['orderStatus'];

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(placeName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("tripDate: " +
                                        tripDate
                                            .toDate()
                                            .toLocal()
                                            .toString()
                                            .split(" ")[0]),
                                    Text("Price: " + packagePrice),
                                  ],
                                ),
                                trailing: Text(orderStatus),
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1.0,
                              ),
                            ],
                          );
                        });
                  } else {
                    return Text("No Oders...");
                  }
                }),
          ),
        ],
      )),
    );
  }
}
