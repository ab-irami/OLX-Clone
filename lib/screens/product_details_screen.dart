import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:ecom_app/provider/product_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  static const String id = 'product_details_screen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  int _index = 0;
  final _format = NumberFormat('##, ##, ##0');

  late GoogleMapController _mapController;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: 'Seller Location is here',
    );
  }

  _callSeller(number) {
    launch(number);
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    GeoPoint _location = _productProvider.sellerDetails['location'];

    var data = _productProvider.productData;
    var _price = int.parse(data['price']);
    String _formattedPrice = _format.format(_price);

    var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
    var _formattedDate = DateFormat.yMMMd().format(date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          LikeButton(
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  color: Colors.grey.shade300,
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text('Loading your Ad...'),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                imageProvider:
                                    NetworkImage(data['images'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              child: Container(
                                height: 59.0,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data['images'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = i;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(data['images'][i]),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 10.0),
                _loading
                    ? Container()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['title'].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                if (data['category'] == 'Cars')
                                  Text('(${(data['year'])})'),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '\$ $_formattedPrice',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if (data['category'] == 'Cars')
                              Container(
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.filter_alt_outlined,
                                                size: 12.0,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                data['fuel'],
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.av_timer_outlined,
                                                size: 12.0,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                _format.format(
                                                    int.parse(data['kmDrive'])),
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.account_tree_outlined,
                                                size: 12.0,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                data['transmission'],
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.person,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  data['no. of owners'],
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20.0),
                                            Expanded(
                                              child: Container(
                                                child: AbsorbPointer(
                                                  absorbing: true,
                                                  child: TextButton.icon(
                                                    onPressed: () {},
                                                    style: const ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                    icon: const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 12.0,
                                                      color: Colors.black,
                                                    ),
                                                    label: Flexible(
                                                      child: Text(
                                                        _productProvider
                                                                    .sellerDetails ==
                                                                null
                                                            ? ''
                                                            : _productProvider
                                                                    .sellerDetails[
                                                                'address'],
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'POSTED DATE',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formattedDate,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10.0),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data['description']),
                                          const SizedBox(height: 10.0),
                                          if (data['subCat'] ==
                                                  'Mobile Phone' ||
                                              data['subCat'] == null)
                                            Text('Brand: ${data['brand']}'),
                                          if (data['subCat'] == 'Accessories' ||
                                              data['subCat'] == 'Tablets' ||
                                              data['subCat'] ==
                                                  'For Sale: House & Apartments' ||
                                              data['subCat'] ==
                                                  'For Rent: House & Apartments')
                                            Text('Type : ${data['type']}'),
                                          if (data['subCat'] ==
                                                  'For Sale: House & Apartments' ||
                                              data['subCat'] ==
                                                  'For Rent: House & Apartments')
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Bedrooms : ${data['bedrooms']}',
                                                ),
                                                Text(
                                                  'Bathrooms : ${data['bathrooms']}',
                                                ),
                                                Text(
                                                  'Furnishing : ${data['furnishing']}',
                                                ),
                                                Text(
                                                  'Construction Status : ${data['constructionStatus']}',
                                                ),
                                                Text(
                                                  'Building SQFT : ${data['buildingSqft']}',
                                                ),
                                                Text(
                                                  'Carpet SQFT : ${data['carpetSqft']}',
                                                ),
                                                Text(
                                                  'Total Floors : ${data['totalFloors']}',
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 20.0),
                                          Text(
                                            'Ad posted at : $_formattedDate',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue.shade50,
                                    radius: 38,
                                    child: Icon(
                                      CupertinoIcons.person_alt,
                                      color: Colors.red.shade300,
                                      size: 60.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      _productProvider.sellerDetails['name'] ==
                                              null
                                          ? ''
                                          : _productProvider
                                              .sellerDetails['name']
                                              .toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'SEE PROFILE',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12.0,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey),
                            const Text(
                              'Ad Posted at',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              height: 200,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  Center(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          _location.latitude,
                                          _location.longitude,
                                        ),
                                        zoom: 15,
                                      ),
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          (GoogleMapController mapController) {
                                        setState(() {
                                          _mapController = mapController;
                                        });
                                      },
                                    ),
                                  ),
                                  const Center(
                                      child: Icon(Icons.location_on, size: 35)),
                                  const Center(
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.black12,
                                    ),
                                  ),
                                  Positioned(
                                    right: 8.0,
                                    top: 8.0,
                                    child: Material(
                                      elevation: 4,
                                      shape: Border.all(
                                          color: Colors.grey.shade300),
                                      child: IconButton(
                                        onPressed: () {
                                          _mapLauncher(_location);
                                        },
                                        icon: const Icon(
                                            Icons.alt_route_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Ad ID: ${data['postedAt']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Report this ad',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 80)
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {},
                  style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          CupertinoIcons.chat_bubble,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    _callSeller(
                      'tel:${_productProvider.sellerDetails['mobile']}',
                    );
                  },
                  style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          CupertinoIcons.phone,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//format :(