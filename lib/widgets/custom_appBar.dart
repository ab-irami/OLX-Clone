import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/location_screen.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

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
              return appBar(address, context);
            });
          } else {
            return appBar(data['address'], context);
          }
        }

        return appBar('Fetching location', context);
      },
    );
  }

  Widget appBar(address, context) {
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
    );
  }
}
