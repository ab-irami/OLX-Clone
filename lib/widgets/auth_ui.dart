import 'package:ecom_app/screens/authentication/email_auth_screen.dart';
import 'package:ecom_app/screens/authentication/google_auth.dart';
import 'package:ecom_app/screens/authentication/phoneauth_screen.dart';
import 'package:ecom_app/services/phoneauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PhoneAuthScreen.id);
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Continue with phone',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SignInButton(
            Buttons.Google,
            text: 'Continue with Google',
            onPressed: () async {
              User? user =
                  await GoogleAuthentication.signInWithGoogle(context: context);
              if (user != null) {
                PhoneAuthService _authentication = PhoneAuthService();
                _authentication.addUser(context, user.uid);
              }
            },
          ),
          SignInButton(
            Buttons.FacebookNew,
            text: 'Continue with Facebook',
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EmailAuthScreen.id);
            },
            child: Container(
              child: const Text(
                'Login With Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.white,
              ))),
            ),
          ),
        ],
      ),
    );
  }
}
