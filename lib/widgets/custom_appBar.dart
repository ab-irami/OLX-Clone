import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/product_provider.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/location_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:ecom_app/services/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final FirebaseService _service = FirebaseService();
  static final List<Products> _products = [];
  final SearchService _searchService = SearchService();

  String _address = '';
  late DocumentSnapshot sellerDetails;

  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          _products.add(
            Products(
              document: doc,
              title: doc['title'],
              category: doc['category'],
              description: doc['description'],
              subCat: doc['subCat'],
              postedDate: doc['postedAt'],
              price: doc['price'],
            ),
          );
          getSellerAddress(doc['sellerUid']);
        });
      });
    });
    super.initState();
  }

  getSellerAddress(sellerId) {
    _service.getSellerData(sellerId).then((value) {
      setState(() {
        _address = value['address'];
        sellerDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var _productProvider = Provider.of<ProductProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['address'] == null) {
            GeoPoint latlong = data['location'];
            _service
                .getAddress(latlong.latitude, latlong.longitude)
                .then((address) {
              return appBar(address, context, _productProvider, sellerDetails);
            });
          } else {
            return appBar(data['address'], context, _productProvider, sellerDetails);
          }
        }

        return appBar('Fetching location', context, _productProvider, sellerDetails);
      },
    );
  }

  Widget appBar(address, context, _provider, sellerDetails) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LocationScreen(
                popScreen: HomeScreen.id,
              ),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    address,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: TextField(
                        onTap: () {
                          _searchService.search(
                            context: context,
                            productList: _products,
                            address: _address,
                            provider: _provider,
                            sellerDetails: sellerDetails,
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          labelText: 'Find Cars, Mobiles and many more',
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(Icons.notifications_none),
                  const SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
