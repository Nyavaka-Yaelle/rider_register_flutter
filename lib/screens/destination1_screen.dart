import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:rider_register/screens/destination2_screen.dart';

class Destination1Screen extends StatefulWidget {
  final String type;
  const Destination1Screen({Key? key, required this.type}) : super(key: key);

  @override
  State<Destination1Screen> createState() => _Destination1ScreenState();
}

class _Destination1ScreenState extends State<Destination1Screen> {
  GoogleMapController? _mapController;
  LocationData? _currentPosition;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPosition();
    });
    super.initState();
  }

  void _getCurrentPosition() async {
    // Get current location using Geolocator package
    _currentPosition = await Location().getLocation();
    print(
        "camera moved to ${_currentPosition!.latitude} ${_currentPosition!.longitude}");
    setState(() {
      // Move map camera to current location

      _mapController?.moveCamera(CameraUpdate.newLatLng(LatLng(
          _currentPosition!.latitude!.toDouble(),
          _currentPosition!.longitude!.toDouble())));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    // Initialize map controller
    setState(() {
      _mapController = controller;
    });
  }

  void _onAddressSubmitted(String value) async {
    if (value.isNotEmpty) {
      // Navigate to second screen with entered address as argument
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlaceholderScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_currentPosition == null ? " current null" : "not null");
    if (_currentPosition == null)
      return Scaffold(
        appBar: AppBar(
          title: Text('Où voulez-vous être déposé?'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else {
      return Scaffold(
        appBar: AppBar(
          title: (widget.type == "ridee" || widget.type == "caree")
              ? Text('Où voulez-vous être déposé?')
              : Text('Où voulez-vous livrer votre colis?'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(_currentPosition!.latitude!.toDouble(),
                        _currentPosition!.longitude!.toDouble()),
                    zoom: 15),
                myLocationEnabled: true,
                markers: [
                  Marker(
                      markerId: MarkerId('current'),
                      position: LatLng(_currentPosition!.latitude!.toDouble(),
                          _currentPosition!.longitude!.toDouble()),
                      infoWindow: InfoWindow(title: 'Votre position actuelle')),
                ].toSet(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 375.0),
                //a text that say 'Où veux tu être livré ?'
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.55,
                          left: 20.0,
                          top: 10.0),
                      child: Text(
                        'Où souhaitez-vous aller?',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: TextFormField(
                        //reduce the size of the textfield

                        decoration: InputDecoration(
                          hintText: "Point d'arrivée",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        readOnly: true,
                        onTap: () {
                          //Your code here
                          print("tapped");
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Destination2Screen(
                                          type: widget.type,
                                        )));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
