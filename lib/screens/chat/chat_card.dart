import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/chat/chat_conversation_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({Key? key, required this.chatData}) : super(key: key);

  final Map<String, dynamic> chatData;

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;
  String _lastChatDate = '';

  @override
  void initState() {
    getProductDetails();
    getChatTime();
    super.initState();
  }

  getProductDetails() {
    _service
        .getProductDetails(widget.chatData['product']['productId'])
        .then((value) {
      setState(() {
        doc = value;
      });
    });
  }

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch));
    if (_date == _today) {
      setState(() {
        _lastChatDate = 'Today';
      });
    } else {
      setState(() {
        _lastChatDate = _date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc == null
        ? Container()
        : Container(
            child: Stack(
              children: [
                const SizedBox(height: 10.0),
                ListTile(
                  onTap: () {
                    _service.messages
                        .doc(widget.chatData['chatRoomId'])
                        .update({'read': true});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChatConversations(
                          chatRoomId: widget.chatData['chatRoomId'],
                        ),
                      ),
                    );
                  },
                  leading: Container(
                    width: 68,
                    height: 68,
                    child: Image.network(doc?['images'][0]),
                  ),
                  title: Text(
                    doc?['title'],
                    style: TextStyle(
                      fontWeight: widget.chatData['read'] == false
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc?['description'], maxLines: 1),
                      if (widget.chatData['chatData'] != null)
                        Text(
                          widget.chatData['chatData'],
                          maxLines: 1,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                    ],
                  ),
                  trailing: _service.popUpMenu(widget.chatData, context),
                ),
                Positioned(
                  right: 16.0,
                  top: 10.0,
                  child: Text(_lastChatDate),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
          );
  }
}
