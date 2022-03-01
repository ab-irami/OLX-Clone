import 'package:cloud_firestore/cloud_firestore.dart';
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

  late Stream<QuerySnapshot<Object?>>? chatMessageStream;
  final _chatMessageController = TextEditingController();

  bool _send = false;

  sendMessage() {
    if (_chatMessageController.text.isNotEmpty) {
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
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: chatMessageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, int index) {
                            return Text(snapshot.data!.docs[index]['message']);
                          },
                        )
                      : Container();
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
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

//appBar