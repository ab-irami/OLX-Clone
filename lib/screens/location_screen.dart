// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:geocoding/geocoding.dart' as geocode;

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key, this.popScreen}) : super(key: key);

  static const String id = 'location_screen';

  final String? popScreen;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final FirebaseService _service = FirebaseService();

  bool _loading = false;
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  String? _address = "";

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? manualAddress;

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    List<geocode.Placemark> placemarks = await geocode.placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);

    String? street = placemarks[0].street;
    String? locality = placemarks[0].locality;
    String? subAdministrativeArea = placemarks[0].subAdministrativeArea;
    String? administrativeArea = placemarks[0].administrativeArea;

    var userSelectedLocation =
        '$street, $locality, $subAdministrativeArea, $administrativeArea';

    setState(() {
      _address = userSelectedLocation;
      countryValue = placemarks[0].country;
    });

    return _locationData;
  }

  @override
  void initState() {
    if (widget.popScreen == null) {
      _service.users
          .doc(_service.user!.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          if (document['address'] != null) {
            if (mounted) {
              setState(() {
                _loading = true;
              });
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          } else {
            setState(() {
              _loading = false;
            });
          }
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching Location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    showBottomScreen(BuildContext context) {
      getLocation().then(
        (location) {
          if (location != null) {
            progressDialog.dismiss();
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    const SizedBox(height: 26.0),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          height: 40.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Search City, area or neighborhood',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        progressDialog.show();
                        getLocation().then((value) {
                          if (value != null) {
                            _service.updateUser(
                              {
                                'location':
                                    GeoPoint(value.latitude!, value.longitude!),
                                'address': _address,
                              },
                              context,
                              //widget.popScreen,
                            ).then((value) {
                              progressDialog.dismiss();
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0.0,
                      leading: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Use Current Location',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        location == null ? 'Fetching Location' : _address!,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4.0, left: 10.0),
                        child: Text(
                          'CHOOSE CITY',
                          style: TextStyle(
                            color: Colors.blueGrey.shade900,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CSCPicker(
                        flagState: CountryFlag.DISABLE,
                        layout: Layout.vertical,
                        dropdownDecoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        defaultCountry: DefaultCountry.India,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            manualAddress =
                                ' $cityValue, $stateValue, $countryValue ';
                          });

                          if (value != null) {
                            _service.updateUser(
                              {
                                'address': manualAddress,
                                'state': stateValue,
                                'city': cityValue,
                                'country': countryValue,
                              },
                              context,
                            ); //widget.popScreen
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            progressDialog.dismiss();
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              Image.asset('images/location_img.jpeg'),
              const SizedBox(height: 20.0),
              const Text(
                'Where do you want\nto buy/sell products',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'To enjoy all that we have to offer you\nwe need to know where to look for them.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 30.0),
              _loading
                  ? Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text('Finding location..'),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 10.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _loading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      )
                                    : ElevatedButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          progressDialog.show();
                                          getLocation().then(
                                            (value) {
                                              if (value != null) {
                                                _service.updateUser(
                                                  {
                                                    'address': _address,
                                                    'location': GeoPoint(
                                                      value.latitude!,
                                                      value.longitude!,
                                                    ),
                                                  },
                                                  context,
                                                  //widget.popScreen,
                                                );
                                              }
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.location_fill,
                                        ),
                                        label: const Padding(
                                          padding: EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                          ),
                                          child: Text(
                                            'Around me',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            progressDialog.show();
                            showBottomScreen(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 2.0),
                                ),
                              ),
                              child: const Text(
                                'Set Location Manually',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
