import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/forms/seller_car_form.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/sell_items/seller_sub_cat_list_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerCategoryListScreen extends StatelessWidget {
  const SellerCategoryListScreen({Key? key}) : super(key: key);

  static const String id = 'seller_category_list_screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Choose Categories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<QuerySnapshot>(
            future:
                _service.categories.orderBy('sortId', descending: false).get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          _catProvider.getCategory(doc['catName']);
                          _catProvider.getCatSnapShot(doc);
                          if (doc['subCat'] == null) {
                            Navigator.pushNamed(context, SellerCarForm.id);
                          } else {
                            Navigator.pushNamed(
                              context,
                              SellerSubCatListScreen.id,
                              arguments: doc,
                            );
                          }
                        },
                        leading: Image.network(
                          doc['image'],
                          width: 40.0,
                        ),
                        title: Text(
                          doc['catName'],
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: doc['subCat'] == null
                            ? null
                            : const Icon(
                                Icons.arrow_forward_ios,
                                size: 12.0,
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
