// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/authentication/otp_screen.dart';
import 'package:ecom_app/screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context, uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot result =
        await users.where('uid', isEqualTo: user?.uid).get();

    List<DocumentSnapshot> document = result.docs;
    if (document.isNotEmpty) {
        Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else {
      return users.doc(user?.uid).set({
        'uid': user?.uid,
        'mobile': user?.phoneNumber,
        'email': user?.email,
        'name': null,
        'address': null,
      }).then((value) {
        auth.authStateChanges().listen((value) {
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        });
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      UserCredential result = await auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {
        addUser(context, user.uid);
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print('error is $e');
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    try {
      auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }
}
