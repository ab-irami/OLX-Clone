// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  const ChatStream({Key? key, this.chatRoomId}) : super(key: key);

  final String? chatRoomId;

  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  final FirebaseService _service = FirebaseService();
  Stream<QuerySnapshot<Object?>>? chatMessageStream;
  DocumentSnapshot? chatDoc;
  final _format = NumberFormat('##,##,##0');

  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    _service.messages.doc(widget.chatRoomId).get().then((value) {
      setState(() {
        chatDoc = value;
      });
    });
    super.initState();
  }

  String _priceFormatted(price) {
    var _price = int.parse(price);
    var _priceFormatted = _format.format(_price);
    return _priceFormatted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
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

          return snapshot.hasData
              ? Column(
                  children: [
                    if (chatDoc != null)
                      ListTile(
                        leading: Container(
                          width: 68,
                          height: 68,
                          child: Image.network(
                            chatDoc?['product']['productImage'],
                          ),
                        ),
                        title: Text(
                          chatDoc?['product']['title'],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$ ${_priceFormatted(chatDoc?['product']['price'])}'),
                            const SizedBox(width: 20.0,),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, int index) {
                          String sentBy = snapshot.data!.docs[index]['sentBy'];
                          String me = _service.user!.uid;
                    
                          String lastChatDate;
                          var _date = DateFormat.yMMMd().format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  snapshot.data!.docs[index]['time']));
                    
                          var _today = DateFormat.yMMMd().format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  DateTime.now().microsecondsSinceEpoch));
                    
                          if (_date == _today) {
                            lastChatDate = DateFormat('hh:mm').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    snapshot.data!.docs[index]['time']));
                          } else {
                            lastChatDate = _date.toString();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ChatBubble(
                                  alignment: sentBy == me
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  backGroundColor: sentBy == me
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['message'],
                                      style: TextStyle(
                                        color: sentBy == me
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  clipper: ChatBubbleClipper2(
                                    type: sentBy == me
                                        ? BubbleType.sendBubble
                                        : BubbleType.receiverBubble,
                                  ),
                                ),
                                Align(
                                  alignment: sentBy == me
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text(
                                    lastChatDate,
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                child: Text('You have no data :('),
              );
        },
      ),
    );
  }
}


///91