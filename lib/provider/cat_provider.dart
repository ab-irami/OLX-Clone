import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  late DocumentSnapshot doc;
  late DocumentSnapshot userDetails;
  late String selectedCategory;
  late String selectedSubCategory;
  List<String> listUrls = [];
  Map<String, dynamic> dataToFirestore = {};

  final FirebaseService _service = FirebaseService();

  getCategory(selectedCat) {
    selectedCategory = selectedCat;
    notifyListeners();
  }

  getSubCategory(selectedSubCat) {
    selectedSubCategory = selectedSubCat;
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

  getUserDetails() {
    _service.getUserData().then((value) {
      userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    listUrls = [];
    dataToFirestore = {};
    notifyListeners();
  }
}
