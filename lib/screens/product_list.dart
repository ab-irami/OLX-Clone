import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:ecom_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key, this.proScreen}) : super(key: key);

  final bool? proScreen;

  @override
  Widget build(BuildContext context) {
    final FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    final _format = NumberFormat('##,##,##0');

    String _formattedKm(km) {
      var _km = int.parse(km);
      var _formattedKm = _format.format(_km);
      return _formattedKm;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: FutureBuilder<QuerySnapshot>(
          future: _catProvider.selectedCategory == 'Cars'
              ? _service.products
                  .orderBy('postedAt')
                  .where('category', isEqualTo: _catProvider.selectedCategory)
                  .get()
              : _service.products
                  .orderBy('postedAt')
                  .where('subCat', isEqualTo: _catProvider.selectedSubCategory)
                  .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140.0, right: 140.0),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No products added\nunder selected Category.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proScreen == false)
                  Container(
                    height: 56.0,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Fresh Recommendations',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 8.8,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data!.docs[index];
                    var price = int.parse(data['price']);
                    String _formattedPrice = '\$ ${_format.format(price)}';

                    return ProductCard(
                      data: data,
                      formattedPrice: _formattedPrice,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
