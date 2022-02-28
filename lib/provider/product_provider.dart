import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ProductProvider with ChangeNotifier {
  late DocumentSnapshot productData;
  late DocumentSnapshot sellerDetails;

  getProductDetails(details) {
    productData = details;
    notifyListeners();
  }

  getSellerDetails(details) {
    sellerDetails = details;
    notifyListeners();
  }
}
