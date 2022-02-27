import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserReviewScreen extends StatelessWidget {
  const UserReviewScreen({Key? key}) : super(key: key);

  static const String id = 'user_review_screen';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var _nameController = TextEditingController();
    var _countryCodeController = TextEditingController();
    var _phoneController = TextEditingController();
    var _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Review Your Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      radius: 38,
                      child: Icon(
                        CupertinoIcons.person_alt,
                        color: Colors.red.shade300,
                        size: 60.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
