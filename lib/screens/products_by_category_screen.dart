// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductByCategoryScreen extends StatelessWidget {
  const ProductByCategoryScreen({Key? key}) : super(key: key);

  static const String id = 'product_by_category_screen';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          _catProvider.selectedSubCategory == null
              ? 'Cars'
              : '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCategory}',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: const SingleChildScrollView(child: ProductList(proScreen: true)),
    );
  }
}
