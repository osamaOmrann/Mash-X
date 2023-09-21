/*
import 'package:flutter/material.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  TextEditingController addressController = TextEditingController();
  LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Demo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Enter address',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getLocationFromAddress();
            },
            child: Text('Show Location'),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation ?? LatLng(0, 0),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: currentLocation ?? LatLng(0, 0),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocationFromAddress() async {
    List<Address> addresses =
    await Geocoder.local.findAddressesFromQuery(addressController.text);
    if (addresses.isNotEmpty) {
      Address firstAddress = addresses.first;
      setState(() {
        currentLocation =
            LatLng(firstAddress.coordinates.latitude, firstAddress.coordinates.longitude);
      });
      mapController.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    }
  }
}*/
