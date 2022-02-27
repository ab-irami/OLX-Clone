import 'package:flutter/material.dart';

class MyAdScreen extends StatelessWidget {
  const MyAdScreen({Key? key}) : super(key: key);

  static const String id = 'my_ad_screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('My ad')),
    );
  }
}
