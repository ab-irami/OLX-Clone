import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  late DocumentSnapshot doc;
  late String selectedCategory;
  List<String> listUrls = [];
  Map<String, dynamic> dataToFirestore = {};

  getCategory(selectedCat) {
    selectedCategory = selectedCat;
    notifyListeners();
  }

  getCatSnapShot(snapShot) {
    doc = snapShot;
    notifyListeners();
  }

  getImages(url) {
    listUrls.add(url);
    notifyListeners();
  }

  getData(data) {
    dataToFirestore = data;
    notifyListeners();
  }
}
