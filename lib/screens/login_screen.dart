import 'package:flutter/material.dart';
import 'package:ecom_app/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueAccent,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  Image.asset(
                    'images/ecom_app_icon-transparent.png',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'OLX Clone',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: const AuthUi(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'If you continue, you are accepting\nTerms and Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
