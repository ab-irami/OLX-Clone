import 'package:ecom_app/screens/chat/chat_stream.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class ChatConversations extends StatefulWidget {
  const ChatConversations({Key? key, this.chatRoomId}) : super(key: key);

  final String? chatRoomId;

  @override
  _ChatConversationsState createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  final FirebaseService _service = FirebaseService();

  final _chatMessageController = TextEditingController();

  bool _send = false;

  sendMessage() {
    if (_chatMessageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': _chatMessageController.text,
        'sentBy': _service.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };

      _service.createChat(widget.chatRoomId, message);
      _chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          _service.popUpMenu(widget.chatRoomId, context),
        ],
        shape: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(
              chatRoomId: widget.chatRoomId,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade800)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatMessageController,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            hintText: 'Type Message',
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _send = true;
                              });
                            } else {
                              setState(() {
                                _send = false;
                              });
                            }
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              sendMessage();
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(
                          onPressed: sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
