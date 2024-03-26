import 'dart:math';
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

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot?> getUserById(String userId) async {
    try {
      DocumentSnapshot? user = await users.doc(userId).get();
      return user;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

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

  //Order ID
  String generateOrderID() {
    // Get the current date in the format YYYY-MM
    String currentDate =
        DateTime.now().toLocal().toString().substring(0, 7).replaceAll('-', '');

    // Format the counter with leading zeros
    Random random = Random();
    int formattedCounter = random.nextInt(999999) + 100000;

    // Create the package ID
    String packageID = 'ODR-$currentDate-$formattedCounter';

    return packageID;
  }

  //create data
  Future<bool> addPackage(
      String packageName,
      String tourType,
      String placeName,
      GeoPoint position,
      String price,
      String vehicalType,
      String tCount,
      String images) async {
    String generatedPackageID = generatePackageID();
    try {
      await package.add({
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
      return true;
    } catch (e) {
      print('Error adding package: $e');
      return false;
    }
  }

  //read data
  Stream<QuerySnapshot> getPackageStream() {
    final packagesStream =
        package.orderBy('timestamp', descending: true).snapshots();
    return packagesStream;
  }

  //update data
  Future<bool> updatePackage(
      String docID,
      String newPackageName,
      String tourType,
      String placeName,
      GeoPoint position,
      String price,
      String vehicalType,
      String tCount,
      String images) async {
    try {
      await package.doc(docID).update({
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
      return true;
    } catch (e) {
      print('Error updating package: $e');
      return false;
    }
  }

  //delete data
  Future<bool> deletePackage(String docID) async {
    try {
      await package.doc(docID).delete();
      return true;
    } catch (e) {
      print('Error deleting package: $e');
      return false;
    }
  }

  //package add for payment
  //create orders
  Future<bool> createOrder(
      String packageId,
      String tourGuiderId,
      String tourType,
      String placeName,
      GeoPoint position,
      DateTime tripDate,
      String amount,
      String tCount,
      String orderStatus) async {
    String generatedOrderID = generateOrderID();
    try {
      await order.add({
        'orderId': generatedOrderID,
        'addedBy': user!.uid,
        'timestamp': Timestamp.now(),
        'packageId': packageId,
        'tourGuiderId': tourGuiderId,
        'tourType': tourType,
        'placeName': placeName,
        'position': position,
        'tripDate': tripDate,
        'amount': amount,
        'tCount': tCount,
        'orderStatus': orderStatus
      });
      return true;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  //read orders
  Stream<QuerySnapshot> getOrderStream() {
    final orderStream =
        order.orderBy('timestamp', descending: true).snapshots();
    return orderStream;
  }

  Stream<QuerySnapshot> setOrderById(userId) {
    final userOrders = order.where('addedBy', isEqualTo: userId).snapshots();

    return userOrders;
  }
}
