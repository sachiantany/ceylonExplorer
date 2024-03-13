import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FirestoreServices {
  //get all data
  final CollectionReference package =
      FirebaseFirestore.instance.collection('packages');

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
      String packageName, String placeName, String position, String price) {
    String generatedPackageID = generatePackageID();
    return package.add({
      'packageName': packageName,
      'timestamp': Timestamp.now(),
      'packageId': generatedPackageID,
      'placeName': placeName,
      'position': position,
      'price': price
    });
  }

  //read data
  Stream<QuerySnapshot> getPackageStream() {
    final packagesStream =
        package.orderBy('timestamp', descending: true).snapshots();
    return packagesStream;
  }

  //update data
  Future<void> updatePackage(String docID, String newPackageName,
      String placeName, String position, String price) {
    return package.doc(docID).update({
      'packageName': newPackageName,
      'timestamp': Timestamp.now(),
      'placeName': placeName,
      'position': position,
      'price': price
    });
  }

  //delete data
  Future<void> deletePackage(String docID) {
    return package.doc(docID).delete();
  }
}
