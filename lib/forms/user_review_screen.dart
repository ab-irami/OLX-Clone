import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/location_screen.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({Key? key}) : super(key: key);

  static const String id = 'user_review_screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final FirebaseService _service = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+91');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _loading = false;

  Future<void> updateUser(provider, Map<String, dynamic> data, context) {
    return _service.users
        .doc(_service.user?.uid)
        .update(data)
        .then((value) => saveProductToDB(provider, context))
        .catchError((error) {
      print('Firebase_service - $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<void> saveProductToDB(CategoryProvider provider, context) {
    return _service.products
        .add(provider.dataToFirestore)
        .then((value) {
      provider.clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'We have received your products and will notify you once get approved.'),
        ),
      );
      Navigator.pushReplacementNamed(context, MainScreen.id);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showConfirmDialog(context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Are you sure, you want to save below product'),
                    const SizedBox(height: 10.0),
                    ListTile(
                      leading:
                          Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(
                        _provider.dataToFirestore['title'],
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        _provider.dataToFirestore['price'],
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          onPressed: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style: NeumorphicStyle(
                            border: NeumorphicBorder(
                              color: Theme.of(context).primaryColor,
                            ),
                            color: Colors.transparent,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 10.0),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            updateUser(
                              _provider,
                              {
                                'contactDetails': {
                                  'contactNumber': _phoneController.text,
                                  'contactEmail': _emailController.text,
                                },
                                'name': _nameController.text,
                              },
                              context,
                            ).then((value) {
                              setState(() {
                                _loading = false;
                              });
                            });
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    if (_loading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
    }

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
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

            _nameController.text = snapshot.data!['name'];
            _phoneController.text = snapshot.data!['mobile'].subString(3);
            _emailController.text = snapshot.data!['email'];
            _addressController.text = snapshot.data!['address'];
            return SingleChildScrollView(
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your name';
                              } else {
                                return null;
                              }
                            },
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
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _countryCodeController,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              helperText: '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Contact Number',
                              helperText: 'Enter your mobile number',
                            ),
                            maxLength: 10,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter mobile number';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        helperText: 'Enter your Email',
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _addressController,
                            minLines: 2,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Address*',
                              helperText: 'Contact address',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please complete required field.';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LocationScreen(
                                  popScreen: UserReviewScreen.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showConfirmDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter required fields'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
