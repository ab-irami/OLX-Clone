import 'package:ecom_app/provider/cat_provider.dart';
import 'package:flutter/material.dart';

class FormClass {
  List accessories = ['Mobiles', 'Tablets'];

  List tablets = ['iPads', 'Samsung', 'Other tablets'];

  List apartmentType = ['Apartments', 'Farm Houses', 'Houses & Villas'];

  List numbers = ['1', '2', '3', '4', '4+'];

  List furnishing = ['Furnished', 'Semi-furnished', 'Unfurnished'];

  List consStatus = ['New Launch', 'Ready to move', 'Under Construction'];

  Widget appBar(CategoryProvider provider) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      title: Text(
        provider.selectedSubCategory,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
