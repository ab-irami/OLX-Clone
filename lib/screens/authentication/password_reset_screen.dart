import 'package:ecom_app/screens/authentication/email_auth_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  static const String id = 'password_reset_screen';

  @override
  Widget build(BuildContext context) {
    var _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                  size: 75.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Forgot\npassword',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Send your email,\nwe will send link to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'Registered Email',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(_emailController.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return 'Enter valid Email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FirebaseAuth.instance
                .sendPasswordResetEmail(email: _emailController.text)
                .then((value) {
              Navigator.pushReplacementNamed(context, EmailAuthScreen.id);
            });
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Send'),
        ),
      ),
    );
  }
}
