import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:ecom_app/screens/sell_items/seller_category_list_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:ecom_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAdScreen extends StatelessWidget {
  const MyAdScreen({Key? key}) : super(key: key);

  static const String id = 'my_ad_screen';

  @override
  Widget build(BuildContext context) {
    final FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');

    String _formattedKm(km) {
      var _km = int.parse(km);
      var _formattedKm = _format.format(_km);
      return _formattedKm;
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            'My Ads',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            indicatorWeight: 6,
            tabs: [
              Tab(
                child: Text(
                  'ADS',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'FAVORITES',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products
                      .where('sellerUid', isEqualTo: _service.user!.uid)
                      .orderBy('postedAt')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 140.0, right: 140.0),
                        child: Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No Ads given yet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SellerCategoryListScreen.id);
                              },
                              child: const Text('Add Products'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56.0,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'My Ads',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8.8,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data!.docs[index];
                              var price = int.parse(data['price']);
                              String _formattedPrice =
                                  '\$ ${_format.format(price)}';

                              return ProductCard(
                                data: data,
                                formattedPrice: _formattedPrice,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _service.products
                      .where('favourite', arrayContains: _service.user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 140.0, right: 140.0),
                        child: Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No Favourites yet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, MainScreen.id);
                              },
                              child: const Text('Add Favourites'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56.0,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'My Favourites',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8.8,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data!.docs[index];
                              var price = int.parse(data['price']);
                              String _formattedPrice =
                                  '\$ ${_format.format(price)}';

                              return ProductCard(
                                data: data,
                                formattedPrice: _formattedPrice,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
