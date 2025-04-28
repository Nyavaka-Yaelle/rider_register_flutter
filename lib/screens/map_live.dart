import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:rider_register/repository/position_repository.dart';

import '../models/position.dart';
import '../repository/livraison_repository.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class Map_live extends StatefulWidget {
  final String idLivraison;

  Map_live({required this.idLivraison});

  @override
  _Map_live_state createState() => _Map_live_state();
}

class _Map_live_state extends State<Map_live> {
  Set<Marker> _markers = Set<Marker>();
  MapsRoutes route = MapsRoutes();
  Completer<GoogleMapController> _controller = Completer();
  String googleApiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
  String totalDistance = 'Status';

  LivraisonRepository livraisonRepository = LivraisonRepository();
  PositionRepository positionRepository = PositionRepository();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    //access widget.idLivraison
    String idLivraison = widget.idLivraison;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/anya.png')
        .then((onValue) {
      print("icon " + onValue.toString());
      pinLocationIcon = onValue;
    });

    //Listen position change
    // call async function in initestate
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/anya.png', 64);
      final BitmapDescriptor bitmapDescriptor =
          BitmapDescriptor.fromBytes(markerIcon);
      livraisonRepository.getLivraisonById(widget.idLivraison).then((value) {
        print("idrider " + value!.idrider.toString());
        positionRepository
            .listenPosition(value!.idrider.toString())
            .listen((event) async {
          print("niova ra zao");
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(double.parse(event.latitude.toString()),
                      double.parse(event.longitude.toString())),
                  zoom: 15.0)));

          setState(() {
            _markers.removeWhere((m) => m.markerId.value == 'rider');
            _markers.add(Marker(
              markerId: MarkerId('rider'),
              position: LatLng(double.parse(event.latitude.toString()),
                  double.parse(event.longitude.toString())),
              infoWindow: InfoWindow(title: 'Position du livreur'),
              icon: bitmapDescriptor,
            ));
          });
        });
      });
    });
  }

  //getlivraison by id

  @override
  Widget build(BuildContext context) {
    Future<Livraison?> livraison =
        livraisonRepository.getLivraisonById(widget.idLivraison);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carte en direct'),
      ),
      body: FutureBuilder<Livraison?>(
        future: livraison,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<LatLng> points = [
              LatLng(double.parse(snapshot.data!.latitudeDepart.toString()),
                  double.parse(snapshot.data!.longitudeDepart.toString())),
              LatLng(double.parse(snapshot.data!.latitudeArrivee.toString()),
                  double.parse(snapshot.data!.longitudeArrivee.toString()))
            ];

            LatLng center = LatLng(
                ((double.parse(snapshot.data!.latitudeDepart.toString()) +
                        double.parse(
                            snapshot.data!.latitudeArrivee.toString())) /
                    2),
                ((double.parse(snapshot.data!.longitudeDepart.toString()) +
                        double.parse(
                            snapshot.data!.longitudeArrivee.toString())) /
                    2));

            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    polylines: route.routes,
                    markers: _markers,
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
                        totalDistance = snapshot.data!.statut.toString();
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
                          child: Text(totalDistance,
                              style: TextStyle(fontSize: 25.0)),
                        )),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
