import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/categories/sub_cat_list_screen.dart';
import 'package:ecom_app/screens/products_by_category_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  static const String id = 'category_list_screen';

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
          'Categories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.orderBy('sortId').get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: const Center(
                    child: Text('Error loading..\nContact developer'),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var doc = snapshot.data?.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          _catProvider.getCategory(doc!['catName']);
                          _catProvider.getCatSnapShot(doc);
                          if (doc['subCat'] == null) {
                            _catProvider.getSubCategory(null);
                            Navigator.pushNamed(
                                context, ProductByCategoryScreen.id);
                          } else {
                            Navigator.pushNamed(
                              context,
                              SubCatListScreen.id,
                              arguments: doc,
                            );
                          }
                        },
                        leading: Image.network(
                          doc?['image'],
                          width: 40.0,
                        ),
                        title: Text(
                          doc?['catName'],
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: doc?['subCat'] == null
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
