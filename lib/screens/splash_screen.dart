import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ecom_app/screens/login_screen.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var colorizeColors = [
    Colors.grey,
    Colors.blueAccent,
  ];

  var colorizeTextStyle = const TextStyle(fontSize: 30.0, fontFamily: 'Lato');

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          if(mounted) {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          }          
        } else {
          if(mounted) {
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }          
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/ecom_app_icon-transparent.png',
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'OLX Clone',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
            ),
          ],
        ),
      ),
    );
  }
}
