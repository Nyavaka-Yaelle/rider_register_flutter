import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/screens/destination3loading_screen.dart';
import 'package:rider_register/services/api_service.dart' as api_service;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:rider_register/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:rider_register/widgets/ridee/your_position_card.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';

import '../main.dart';
import '../models/commande.dart';

class Destination3Screen extends StatefulWidget {
  final LatLng depart;
  final LatLng arrivee;
  final String type;

  Destination3Screen(
      {required this.depart, required this.arrivee, required this.type});

  @override
  _Destination3ScreenState createState() => _Destination3ScreenState();
}

class _Destination3ScreenState extends State<Destination3Screen> {
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  MapsRoutes route = new MapsRoutes();

  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String googleApiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
  String totalDistance = 'No route';
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool isWaitASec = false;
  //cusotm bottom sheet
  void _showBottomSheet() {
    showCustomBottomSheet(
      context,
      height: 250.v,
      children: [
        SizedBox(height: 12.v),
        YourPositionCard(
          position: Provider.of<DeliveryData>(context, listen: false)
                  .multipointAddress![
              Provider.of<DeliveryData>(context, listen: false)
                      .multipointAddress!
                      .length -
                  1]["address"],
          positiondepart: Provider.of<DeliveryData>(context, listen: false)
              .departAddressRidee!,
        ),
        SizedBox(height: 8.h),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
        CustomElevatedButton(
          width: 327.v,
          height: 48.v,
          text: "Chercher un rider",
          onPressed: () {
            _handleButtonClick();
          },
          // buttonStyle: CustomButtonStyles.fillGrayE,
          // buttonTextStyle: CustomTextStyles.bodyLargeGray90003,
        ),
      ],
    );
  }

  void _handleButtonClick() {
    setState(() {
      isWaitASec = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isWaitASec = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Destination3loadingScreen(
                  depart: test1,
                  commande: Commande.empty(),
                  type: widget.type,
                )),
      );
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      print("show bottom sheet");
      _showBottomSheet();
    });
    super.initState();
  }

  var choices = [
    // {
    //   'image': 'assets/images/logo.png',
    //   'text1': 'Ridee',
    //   'text2': '1 personnes',
    // },
    // {
    //   'image': 'assets/logo/Caree-1.png',
    //   'text1': 'Caree',
    //   'text2': '1-2 personnes',
    // },
    // {
    //   'image': 'assets/logo/caree 4+ service.png',
    //   'text1': 'Caree VIP',
    //   'text2': '3-5 personnes',
    // },
  ];
  final moneychoices = [
    // {
    //   'image': 'assets/images/identification-documents.png',
    //   'text1': 'Monee',
    // },
    {
      'image': 'assets/images/identification-documents.png',
      'text1': 'Cash',
    }
  ];
  int currentChoice = 0;
  int currentmoneychoice = 0;
  //function that convert list of marker to list of latlng
  List<LatLng> _convertMarkerListToLatLng(List<Marker> markers) {
    List<LatLng> latLngs = [];
    for (var i = 0; i < markers.length; i++) {
      latLngs.add(markers[i].position);
    }
    return latLngs;
  }

  //function that convert list of latlng to list of marker
  List<Marker> _convertLatLngListToMarker(List<LatLng> latLngs) {
    List<Marker> markers = [];
    for (var i = 0; i < latLngs.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(latLngs[i].toString()),
          position: latLngs[i],
          icon: BitmapDescriptor.defaultMarker));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    test1 = widget.depart;
    test2 = widget.arrivee;
    if (widget.type == "ridee") {
      choices = [
        {
          'image': 'assets/images/logo.png',
          'text1': 'Ridee',
          'text2': '1 personnes',
        },
      ];
    } else if (widget.type == "caree") {
      choices = [
        {
          'image': 'assets/logo/Caree-1.png',
          'text1': 'Caree',
          'text2': '1-2 personnes',
        },
        {
          'image': 'assets/logo/caree 4+ service.png',
          'text1': 'Caree VIP',
          'text2': '3-5 personnes',
        },
      ];
    } else {
      choices = [
        {
          'image': 'assets/images/logo.png',
          'text1': 'Ridee',
          'text2': '1 personnes',
        },
        {
          'image': 'assets/logo/Caree-1.png',
          'text1': 'Caree',
          'text2': '1-2 personnes',
        },
        {
          'image': 'assets/logo/caree 4+ service.png',
          'text1': 'Caree VIP',
          'text2': '3-5 personnes',
        },
      ];
    }
    final _textControllerDepartRidee = TextEditingController();
    final _textControllerDeliveryRidee = TextEditingController();
    print("aAAA ${context.watch<DeliveryData>().deliveryAddressRidee} ");
    print("bbbb ${context.watch<DeliveryData>().departAddressRidee} ");

    _textControllerDepartRidee.text =
        context.watch<DeliveryData>().departAddressRidee!;
    _textControllerDeliveryRidee.text = context
            .watch<DeliveryData>()
            .multipointAddress![
        context.watch<DeliveryData>().multipointAddress!.length - 1]["address"];
    List<LatLng>? multipoint = context.watch<DeliveryData>().multipoint;
    List<LatLng> points = [];
    List<Marker> markers = _convertLatLngListToMarker(multipoint!);
    if (widget.type == "packee") {
      points.addAll(multipoint);

      points.add(test1);
    } else {
      points.add(test1);
      points.addAll(multipoint);
    }

    //print element of points

    LatLng center = LatLng(((test1.latitude + test2.latitude) / 2),
        ((test1.longitude + test2.longitude) / 2));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualiser votre trajet',
          // 'Valider la destination'
        ),
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: GoogleMap(
            zoomControlsEnabled: false,
            polylines: _polylines,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              zoom: 13.0,
              target: center,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              for (var i = 0; i < points.length; i++) {
                print("point $i" + points[i].toString() + " ");
              }

              //make route optimized
              // await route.drawRoute(points, 'Test routes',
              //     Color.fromRGBO(105, 72, 155, 1), googleApiKey,
              //     travelMode: TravelModes.driving);
              for (int i = 0; i < points.length - 1; i++) {
                PolylinePoints polylinePoints = PolylinePoints();

                PolylineResult result =
                    await polylinePoints.getRouteBetweenCoordinates(
                  googleApiKey,
                  PointLatLng(points[i].latitude, points[i].longitude),
                  PointLatLng(points[i + 1].latitude, points[i + 1].longitude),
                );
                if (result.points.isNotEmpty) {
                  // loop through all PointLatLng points and convert them
                  // to a list of LatLng, required by the Polyline
                  print("not empty");
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates
                        .add(LatLng(point.latitude, point.longitude));
                  });
                }
              }
              setState(() {
                _polylines.add(Polyline(
                  polylineId: PolylineId('route'),
                  color: Colors.red,
                  width: 5,
                  points: polylineCoordinates,
                ));
              });
              //marker icon and bitmap descriptor
              Uint8List? markerIcon =
                  await getBytesFromAsset('assets/logo/Point Arriver.png', 64);
              BitmapDescriptor bitmapDescriptor =
                  BitmapDescriptor.fromBytes(markerIcon!);
              Uint8List? markerIcon2 =
                  await getBytesFromAsset('assets/logo/point Prendre.png', 64);
              BitmapDescriptor bitmapDescriptor2 =
                  BitmapDescriptor.fromBytes(markerIcon2!);
              //set marker for depart and arrivee
              Marker markerDepart = Marker(
                markerId: MarkerId('depart'),
                position: test1,
                icon: bitmapDescriptor2,
                infoWindow: InfoWindow(title: 'Départ'),
              );

              //add marker to map

              setState(() {
                _markers!.add(markerDepart);
                _markers!.addAll(markers);
                totalDistance = distanceCalculator
                    .calculateRouteDistance(points, decimals: 1);
              });
            },
          ),
        ),
        // an icon on the left , a text and another text on the right , and 3 Dots that display a choice of thing that change the two text and the icon
        // Expanded(
        //   flex: 0,
        //   child:
        //       Row(// Use a row to display the icon, text and button horizontally
        //           children: [
        //     SizedBox(width: 25),
        //     Image(
        //       image: AssetImage(choices[currentChoice]['image'] as String),
        //       width: 64,
        //       height: 64,
        //     ),
        //     SizedBox(width: 10),
        //     Text(choices[currentChoice]['text1'] as String,
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        //     Spacer(),
        //     Text(choices[currentChoice]['text2'] as String),
        //     IconButton(
        //         icon: Icon(Icons.more_vert),
        //         onPressed: () {
        //           showDialog(
        //               context: context,
        //               builder: (context) {
        //                 return AlertDialog(
        //                     title: Text('Sélectionner une option'),
        //                     content: Column(children: [
        //                       // Loop through the choices and create a list tile for each one
        //                       for (int i = 0; i < choices.length; i++)
        //                         ListTile(
        //                           leading: Image(
        //                             image: AssetImage(
        //                                 choices[i]['image'] as String),
        //                             width: 64,
        //                             height: 64,
        //                           ),
        //                           title: Text(choices[i]['text1'] as String),
        //                           subtitle: Text(choices[i]['text2'] as String),
        //                           onTap: () {
        //                             // Update the current choice index and pop the dialog
        //                             setState(() {
        //                               currentChoice = i;
        //                             });
        //                             Navigator.pop(context);
        //                           },
        //                         ),
        //                     ]));
        //               });
        //         }),
        //   ]),
        // ),
        // Expanded(
        //   flex: 0,
        //   child: Container(
        //     margin: EdgeInsets.all(10),
        //     width: 350,
        //     height: 100,
        //     // padding: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //       // Créer une bordure verte
        //       border: Border.all(color: Colors.green, width: 2),
        //       // Colorer l'arrière-plan en gris
        //       color: Colors.grey.shade300,
        //     ),
        //     child: Column(
        //       children: [
        //         // Créer la première entrée en lecture seule
        //         TextFormField(
        //           readOnly: true,
        //           controller: _textControllerDepartRidee,
        //           decoration: InputDecoration(
        //               hintText: 'Point de départ',
        //               prefixIcon: Icon(Icons.location_on)),
        //         ),
        //         // Créer la deuxième entrée en lecture seule
        //         TextFormField(
        //           readOnly: true,
        //           controller: _textControllerDeliveryRidee,
        //           decoration: InputDecoration(
        //               hintText: "Point d'arrivée",
        //               prefixIcon: Icon(Icons.location_on)),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Expanded(
        //   flex: 0,
        //   child:
        //       Row(// Use a row to display the icon, text and button horizontally
        //           children: [
        //     SizedBox(width: 25),
        //     Image(
        //       image: AssetImage(
        //           moneychoices[currentmoneychoice]['image'] as String),
        //       width: 64,
        //       height: 64,
        //     ),
        //     SizedBox(width: 10),
        //     Text(moneychoices[currentmoneychoice]['text1'] as String,
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        //     Spacer(),
        //     IconButton(
        //         icon: Icon(Icons.more_vert),
        //         onPressed: () {
        //           showDialog(
        //               context: context,
        //               builder: (context) {
        //                 return AlertDialog(
        //                     title: Text('Sélectionner une option'),
        //                     content: Column(children: [
        //                       // Loop through the choices and create a list tile for each one
        //                       for (int i = 0; i < moneychoices.length; i++)
        //                         ListTile(
        //                           leading: Image(
        //                             image: AssetImage(
        //                                 moneychoices[i]['image'] as String),
        //                             width: 64,
        //                             height: 64,
        //                           ),
        //                           title:
        //                               Text(moneychoices[i]['text1'] as String),
        //                           onTap: () {
        //                             // Update the current choice index and pop the dialog
        //                             setState(() {
        //                               currentmoneychoice = i;
        //                             });
        //                             Navigator.pop(context);
        //                           },
        //                         ),
        //                     ]));
        //               });
        //         }),
        //   ]),
        // ),
        // Expanded(
        //   flex: 0,
        //   child: ElevatedButton(
        //     onPressed: isWaitASec ? null : _handleButtonClick,
        //     style: ButtonStyle(
        //       minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
        //     ),
        //     child: Text(isWaitASec ? 'En cours de traitement ...' : 'Valider'),
        //   ),
        // ),
      ]),
    );
  }
}
