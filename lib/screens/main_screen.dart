import 'package:ecom_app/screens/account_screen.dart';
import 'package:ecom_app/screens/chat_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/my_ad_screen.dart';
import 'package:ecom_app/screens/sell_items/seller_category_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String id = 'main_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = const HomeScreen();
  final PageStorageBucket _bucket = PageStorageBucket();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: _bucket,
        child: _currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SellerCategoryListScreen.id);
        },
        backgroundColor: Colors.purple,
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40.0,
                    onPressed: () {
                      setState(() {
                        _index = 0;
                        _currentScreen = const HomeScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 0 ? Icons.home : Icons.home_outlined),
                        Text(
                          'HOME',
                          style: TextStyle(
                            color: _index == 0 ? _color : Colors.black,
                            fontWeight: _index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.0,
                    onPressed: () {
                      setState(() {
                        _index = 1;
                        _currentScreen = const ChatScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 1
                            ? CupertinoIcons.chat_bubble_fill
                            : CupertinoIcons.chat_bubble),
                        Text(
                          'CHATS',
                          style: TextStyle(
                            color: _index == 1 ? _color : Colors.black,
                            fontWeight: _index == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40.0,
                    onPressed: () {
                      setState(() {
                        _index = 2;
                        _currentScreen = const MyAdScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 2
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart),
                        Text(
                          'MY ADS',
                          style: TextStyle(
                            color: _index == 2 ? _color : Colors.black,
                            fontWeight: _index == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.0,
                    onPressed: () {
                      setState(() {
                        _index = 3;
                        _currentScreen = const AccountScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 3
                            ? CupertinoIcons.person_fill
                            : CupertinoIcons.person),
                        Text(
                          'ACCOUNT',
                          style: TextStyle(
                            color: _index == 3 ? _color : Colors.black,
                            fontWeight: _index == 3
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///backgroundColor for FAB purple
