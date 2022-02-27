import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  static const String id = 'account_screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Account')),
    );
  }
}
