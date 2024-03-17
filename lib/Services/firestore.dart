import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FirestoreServices {
  //get all data
  final CollectionReference package =
      FirebaseFirestore.instance.collection('packages');

  final CollectionReference order =
      FirebaseFirestore.instance.collection('orders');

  User? user = FirebaseAuth.instance.currentUser;

  //PKG ID
  String generatePackageID() {
    // Get the current date in the format YYYY-MM
    String currentDate =
        DateTime.now().toLocal().toString().substring(0, 7).replaceAll('-', '');

    // Format the counter with leading zeros
    Random random = Random();
    int formattedCounter = random.nextInt(999999) + 100000;

    // Create the package ID
    String packageID = 'PKG-$currentDate-$formattedCounter';

    return packageID;
  }

  //create data
  Future<void> addPackage(
      String packageName,
      String tourType,
      String placeName,
      GeoPoint position,
      String price,
      String vehicalType,
      String tCount,
      String images) {
    String generatedPackageID = generatePackageID();
    return package.add({
      'packageName': packageName,
      'addedBy': user!.uid,
      'timestamp': Timestamp.now(),
      'tourType': tourType,
      'packageId': generatedPackageID,
      'placeName': placeName,
      'position': position,
      'price': price,
      'vehicalType': vehicalType,
      'tCount': tCount,
      'images': images
    });
  }

  //read data
  Stream<QuerySnapshot> getPackageStream() {
    final packagesStream =
        package.orderBy('timestamp', descending: true).snapshots();
    return packagesStream;
  }

  //update data
  Future<void> updatePackage(
      String docID,
      String newPackageName,
      String tourType,
      String placeName,
      GeoPoint position,
      String price,
      String vehicalType,
      String tCount,
      String images) {
    return package.doc(docID).update({
      'packageName': newPackageName,
      'timestamp': Timestamp.now(),
      'tourType': tourType,
      'placeName': placeName,
      'position': position,
      'price': price,
      'vehicalType': vehicalType,
      'tCount': tCount,
      'images': images
    });
  }

  //delete data
  Future<void> deletePackage(String docID) {
    return package.doc(docID).delete();
  }

  //package add for payment
}
