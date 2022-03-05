// ignore_for_file: prefer_final_fields

import 'package:ecom_app/screens/authentication/phoneauth_screen.dart';
import 'package:ecom_app/services/phoneauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String number, verId;
  const OTPScreen({Key? key, required this.number, required this.verId})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _loading = false;
  String error = '';

  PhoneAuthService _services = PhoneAuthService();

  var _text1 = TextEditingController();
  var _text2 = TextEditingController();
  var _text3 = TextEditingController();
  var _text4 = TextEditingController();
  var _text5 = TextEditingController();
  var _text6 = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> phoneCredential(BuildContext context, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
        if (user != null) {
          _services.addUser(context, user.uid);
        } else {
          if (mounted) {
            setState(() {
              error = 'Login Failed';
            });
          }
        }
    } catch (e) {
      print('err ${e.toString()}');
      if (mounted) {
        setState(() {
          error = 'Invalid OTP';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red.shade200,
                child: const Icon(
                  CupertinoIcons.person_alt_circle,
                  color: Colors.red,
                  size: 60.0,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'We sent a 6-digit code to ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                        children: [
                          TextSpan(
                            text: widget.number,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhoneAuthScreen(),
                        ),
                      );
                    },
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _text1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          node.nextFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _text2,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          node.nextFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _text3,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          node.nextFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _text4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value.length == 1) {
                            node.nextFocus();
                          }
                        }),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _text5,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          node.nextFocus();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _text6,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (_text1.text.length == 1) {
                            if (_text2.text.length == 1) {
                              if (_text3.text.length == 1) {
                                if (_text4.text.length == 1) {
                                  if (_text5.text.length == 1) {
                                    String _otp =
                                        '${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}';
                                    setState(() {
                                      _loading = true;
                                    });
                                    phoneCredential(context, _otp);
                                  }
                                }
                              }
                            }
                          }
                        } else {
                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              if (_loading)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 50.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//otp screen bug phone verification