import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/product_list.dart';
import 'package:ecom_app/widgets/banner_widget.dart';
import 'package:ecom_app/widgets/category_widget.dart';
import 'package:ecom_app/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.clearSelectedCat();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  child: Column(
                    children: const [
                      BannerWidget(),
                      CategoryWidget(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const ProductList(proScreen: false),
            ],
          ),
        ),
      ),
    );
  }
}
