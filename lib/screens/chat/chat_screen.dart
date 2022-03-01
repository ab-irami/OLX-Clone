import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String id = 'chat_screen';

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(child: Text('chat')),
    );
  }
}
