import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

import '../theme/theme_helper.dart';

class MapsRoutesExample extends StatefulWidget {
  double latitudeDepart;
  double longitudeDepart;
  double latitudeArrivee;
  double longitudeArrivee;
  MapsRoutesExample(
      {required this.latitudeDepart,
      required this.longitudeDepart,
      required this.latitudeArrivee,
      required this.longitudeArrivee});

  @override
  _MapsRoutesExampleState createState() => _MapsRoutesExampleState();
}

class _MapsRoutesExampleState extends State<MapsRoutesExample> {
  Completer<GoogleMapController> _controller = Completer();

  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String googleApiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
  String totalDistance = 'No route';

  @override
  Widget build(BuildContext context) {
    List<LatLng> points = [
      LatLng(widget.latitudeDepart, widget.longitudeDepart),
      LatLng(widget.latitudeArrivee, widget.longitudeArrivee)
    ];

    LatLng center = LatLng(
        ((widget.latitudeDepart + widget.latitudeArrivee) / 2),
        ((widget.longitudeDepart + widget.longitudeArrivee) / 2));

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: GoogleMap(
              zoomControlsEnabled: false,
              polylines: route.routes,
              initialCameraPosition: CameraPosition(
                zoom: 15.0,
                target: center,
              ),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                await route.drawRoute(points, 'Test routes',
                    Color.fromRGBO(105, 72, 155, 1), googleApiKey,
                    travelMode: TravelModes.driving);
                setState(() {
                  totalDistance = distanceCalculator
                      .calculateRouteDistance(points, decimals: 1);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      color: scheme.onPrimary,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Align(
                    alignment: Alignment.center,
                    child:
                        Text(totalDistance, style: TextStyle(fontSize: 25.0)),
                  )),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await route.drawRoute(points, 'Test routes',
              Color.fromRGBO(130, 78, 210, 1.0), googleApiKey,
              travelMode: TravelModes.driving);
          setState(() {
            totalDistance =
                distanceCalculator.calculateRouteDistance(points, decimals: 1);
          });
        },
      ),
    );
  }
}
