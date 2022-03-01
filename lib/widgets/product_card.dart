import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/provider/product_provider.dart';
import 'package:ecom_app/screens/product_details_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
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

  String _formattedKm(km) {
    var _km = int.parse(km);
    var _formattedKm = _format.format(_km);
    return _formattedKm;
  }

  @override
  void initState() {
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
    super.initState();
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
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: LikeButton(
                      circleColor: const CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        );
                      },
                    ),
                  ),
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
