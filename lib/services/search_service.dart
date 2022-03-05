import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/product_details_screen.dart';
import 'package:ecom_app/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';

class Products {
  final String title, description, category, subCat, price;
  final dynamic postedDate;
  final DocumentSnapshot document;

  Products(
      {required this.title,
      required this.description,
      required this.category,
      required this.subCat,
      required this.price,
      required this.postedDate,
      required this.document});
}

class SearchService {
  search({context, productList, address, provider, sellerDetails}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
        onQueryUpdate: (s) => print(s),
        items: productList,
        barTheme:  ThemeData(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        searchLabel: 'Search Products',
        searchStyle: const TextStyle(color: Colors.black),
        suggestion:
            const SingleChildScrollView(child: ProductList(proScreen: true)),
        failure: const Center(
          child: Text('No products found :('),
        ),
        filter: (product) => [
          product.title,
          product.description,
          product.subCat,
          product.category
        ],
        builder: (product) {
          final _format = NumberFormat('##,##,##0');
          var price = int.parse(product.price);
          String _formattedPrice = '\$ ${_format.format(price)}';

          var date = DateTime.fromMicrosecondsSinceEpoch(product.postedDate);
          var _formattedDate = DateFormat.yMMMd().format(date);

          return InkWell(
            onTap: () {
              provider.getProductDetails(product.document);
              provider.getSellerDetails(sellerDetails);
              Navigator.pushNamed(context, ProductDetailsScreen.id);
            },
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        child: Image.network(product.document['images'][0]),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formattedPrice,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                product.title,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Posted at : $_formattedDate'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14.0,
                                    color: Colors.black38,
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          148,
                                      child: Text(
                                        address,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
