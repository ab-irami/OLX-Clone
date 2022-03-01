import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;

class FirebaseService {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> updateUser(Map<String, dynamic> data, context, screen) {
    return users
        .doc(user?.uid)
        .update(data)
        .then((value) => Navigator.pushReplacementNamed(context, screen))
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

  Future<DocumentSnapshot> getSellerData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  createChat(String? chatRoomId, message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });
    messages.doc(chatRoomId).update(
        {'lastChat': message['message'], 'lastChatTime': message['time']});
  }

  getChat(chatRoomId) async {
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }
}
