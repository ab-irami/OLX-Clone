import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/chat/chat_card.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:ecom_app/screens/sell_items/seller_category_list_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String id = 'chat_screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            'Chats',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
            labelColor: Theme.of(context).primaryColor,
            indicatorWeight: 6.0,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'BUYING'),
              Tab(text: 'SELLING'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'No Chats started yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: const Text('Contact Seller'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(chatData: data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .where('product.seller', isNotEqualTo: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'No Ads buying yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: const Text('Buy Products'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(chatData: data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .where('product.seller', isEqualTo: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'No Ads given yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, SellerCategoryListScreen.id);
                            },
                            child: const Text('Ad Products'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(chatData: data);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
