import 'package:ecom_app/widgets/banner_widget.dart';
import 'package:ecom_app/widgets/category_widget.dart';
import 'package:ecom_app/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: SafeArea(
          child: CustomAppBar(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            labelText: 'Find Cars, Mobiles and many more',
                            labelStyle: const TextStyle(
                              fontSize: 12.0,
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Icon(Icons.notifications_none),
                    const SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
              child: Column(
                children: const [
                  BannerWidget(),
                  CategoryWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
