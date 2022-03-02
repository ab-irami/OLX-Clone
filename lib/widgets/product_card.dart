import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/product_provider.dart';
import 'package:ecom_app/screens/product_details_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required String formattedPrice,
  })  : _formattedPrice = formattedPrice,
        super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final FirebaseService _service = FirebaseService();

  final _format = NumberFormat('##, ##, ##0');

  String address = '';
  late DocumentSnapshot sellerDetails;
  List fav = [];
  bool isLiked = false;

  String _formattedKm(km) {
    var _km = int.parse(km);
    var _formattedKm = _format.format(_km);
    return _formattedKm;
  }

  @override
  void initState() {
    getSellerData();
    getFavourites();
    super.initState();
  }

  getSellerData() {
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
  }

  getFavourites() {
    _service.products.doc(widget.data.id).get().then((value) {
      if (mounted) {
        setState(() {
          fav = value['favourites'];
        });
      }
      if (fav.contains(_service.user!.uid)) {
        if (mounted) {
          setState(() {
            isLiked = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLiked = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    return InkWell(
      onTap: () {
        _productProvider.getProductDetails(widget.data);
        _productProvider.getSellerDetails(sellerDetails);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100.0,
                          child: Center(
                            child: Image.network(widget.data['images'][0]),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          widget._formattedPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        widget.data['category'] == 'cars'
                            ? Text(
                                '${widget.data['year']} - ${_formattedKm(widget.data['kmDrive'])}km')
                            : const Text(''),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 14.0,
                        color: Colors.black38,
                      ),
                      Flexible(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  color: isLiked ? Colors.red : Colors.black,
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    _service.updateFavourite(isLiked, widget.data.id, context);
                  },
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
