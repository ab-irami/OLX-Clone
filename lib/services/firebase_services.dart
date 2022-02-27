import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;

class FirebaseService {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future<void> updateUser(Map<String, dynamic> data, context) {
    return users
        .doc(user?.uid)
        .update(data)
        .then((value) => Navigator.pushReplacementNamed(context, MainScreen.id))
        .catchError((error) {
      print('Firebase_service - $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<String> getAddress(lat, long) async {
    List<geocode.Placemark> placemarks =
        await geocode.placemarkFromCoordinates(lat, long);

    String? name = placemarks[0].name;
    String? locality = placemarks[0].locality;
    String? country = placemarks[0].country;

    var userSelectedLocation = '$name, $locality, $country';

    return userSelectedLocation;
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user!.uid).get();
    return doc;
  }
}
