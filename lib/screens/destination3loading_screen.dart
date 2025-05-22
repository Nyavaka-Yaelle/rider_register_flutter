import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/components/ridee_card.dart';
import 'package:rider_register/models/commande.dart';
import 'package:rider_register/models/user.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'package:rider_register/screens/destination4_screen.dart';
// import position repository
import 'package:rider_register/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:rider_register/widgets/custom_icon_button.dart';
import 'package:rider_register/widgets/ridee/your_position_card.dart';
import 'package:rider_register/widgets/wallet/card_rider.dart';
import 'package:rider_register/widgets/wallet/label_dark_wallet.dart';
import 'package:rider_register/core/app_export.dart';

import 'dart:typed_data';
import 'dart:ui';

import '../main.dart';
import '../models/position.dart';
import '../repository/position_repository.dart';
import '../repository/user_repository.dart';

// Define the first screen as a stateful widget
class Destination3loadingScreen extends StatefulWidget {
  final LatLng depart;
  final String type;
  final Commande commande;

  Destination3loadingScreen(
      {required this.depart, required this.type, required this.commande});

  @override
  _Destination3loadingScreenState createState() =>
      _Destination3loadingScreenState();
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

// Define the state of the first screen
class _Destination3loadingScreenState extends State<Destination3loadingScreen> {
  // Define a future that waits for x seconds and returns true
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  String totalDistance = 'No route';
  PositionRepository positionRepository = new PositionRepository();
  UserRepository userRepository = new UserRepository();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Uint8List? markerIcon;
  Circle circle = Circle(circleId: CircleId('myCircle'));
  BitmapDescriptor? bitmapDescriptor;
  // Define a variable to store the index of the selected item
  int selectedIndex = -1;
  dynamic selectedrider = {};
  List<Position?> riderpositions = [];
  dynamic rider = [];
  double money = 0;
  bool isLoading = false;
  bool isWaitASec = false;

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
            builder: (context) => Destination4Screen(
                  depart: widget.depart,
                  commande: widget.commande,
                  type: widget.type,
                  rider: selectedrider,
                )),
      );
    });
  }

  void _showBottomSheet() {
    showCustomBottomSheet(
      context,
      children: [
        SizedBox(height: 12.v),
        YourPositionCard(
          position: 'Accès Banque Andavamamba',
          right: LabelDarkWallet(text: '20 000 Ar'),
        ),
        SizedBox(height: 8.h),
        CardRider(
          motor: '423TBL',
          rider: 'Rakoto',
          motorImg: 'https://via.placeholder.com/48x48',
          riderImg: 'https://via.placeholder.com/48x48',
        ),
      ],
    );
  }

  Future<void> rechercher() async {
    setState(() {
      isLoading = true;
    });

    test1 = widget.depart;
    dynamic riderrecherche = [];

    if (widget.type == "packee") {
      //loop through context.read<DeliveryData>().notePackee!
      for (int i = 0;
          i < context.read<DeliveryData>().notePackee!.length;
          i++) {
        money = money +
            double.parse(context.read<DeliveryData>().notePackee![i]["price"]);
      }
      await positionRepository.updateposition(money);
      riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
          context.read<DeliveryData>().multipoint![0].latitude.toString(),
          context.read<DeliveryData>().multipoint![0].longitude.toString(),
          money);
    }
    if (widget.type == "foodee") {
      for (int i = 0; i < widget.commande.prix!.length; i++) {
        money =
            money + (widget.commande.prix![i] * widget.commande.quantites![i]);
      }
      await positionRepository.updateposition(money);

      riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
          widget.depart.latitude.toString(),
          widget.depart.longitude.toString(),
          money);
    }
    if (widget.type == "ridee") {
      money = -1.0;
      await positionRepository.updateposition(money);

      riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
          widget.depart.latitude.toString(),
          widget.depart.longitude.toString(),
          money);
    }
    if (widget.type == "caree") {
      money = -1.0;
      await positionRepository.updateposition(money);

      riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
          widget.depart.latitude.toString(),
          widget.depart.longitude.toString(),
          money);
    }

    print(money.toString() + " money ");
    // riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
    //     widget.depart.latitude.toString(),
    //     widget.depart.longitude.toString(),
    //     money);
    markerIcon = await getBytesFromAsset('assets/logo/Motar.png', 64);
    bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
    if (riderpositions != null) {
      print("riderpositions.length ${riderpositions.length}");
    } else {
      print("riderpositions.length is null");
    }
    print("Length ${riderpositions.length}");
    for (int i = 0; i < riderpositions.length; i++) {
      print("riderpositions[i] ${riderpositions[i]}");
      Rider? user =
          await userRepository.getRiderByUserById(riderpositions[i]!.iduser!);
      //cast string to double
      Marker markerArrivee = Marker(
        markerId: MarkerId(user!.displayName!),
        position: LatLng(double.parse(riderpositions[i]!.latitude!),
            double.parse(riderpositions[i]!.longitude!)),
        infoWindow: InfoWindow(title: user!.displayName!),
        icon: bitmapDescriptor!,
      );
      setState(() {
        _markers!.add(markerArrivee);
      });
      dynamic ridertoshow = {
        'nombreLivraisonsArrived': user.nombreLivraisonsArrived,
        'moyenneNote': user.moyenneNote,
        'vehicleLicencePlate': user.vehicleLicencePlate,
        'profilePicture': user.profilePicture,
        'title': user!.displayName,
        'id': riderpositions[i]!.iduser,
        'position': LatLng(double.parse(riderpositions[i]!.latitude!),
            double.parse(riderpositions[i]!.longitude!)),
        'description': 'You are the one and only',
        'number': '5',
        'anothertext': '2-4 personnes',
      };
      print("Vehicule type " + user.vehicleType.toString());
      if (widget.type == "caree") {
        if (user.vehicleType!.contains("4 roue")) {
          riderrecherche.add(ridertoshow);
        }
      } else if (widget.type == "ridee") {
        if (user.vehicleType!.contains("2 roue") &&
            !user.vehicleType!.contains("Vélo")) {
          riderrecherche.add(ridertoshow);
        }
      } else {
        riderrecherche.add(ridertoshow);
      }
      //check if the rider is null
    }
    rider = riderrecherche;

    //set marker for depart and arrivee
    Marker markerDepart = Marker(
      markerId: MarkerId('Vous'),
      position: test1,
      infoWindow: InfoWindow(title: 'Vous'),
    );

    setState(() {
      _markers!.add(markerDepart);
      circle = circle.copyWith(
        centerParam: test1,
        radiusParam: 2000,
        fillColorParam: Color(0xFF00AD9C)!.withOpacity(0.5),
        strokeColorParam: Color(0xFF00AD9C),
      );
      isLoading = false;
    });
  }

  late Timer _timer;
  int _counter = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rechercher();
    });
    // _showBottomSheet();

    super.initState();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      if (_counter > 6) {
        _timer.cancel();
        return;
      }
      // await rechercher();
      _counter++;
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks.
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("bitmapDescriptor: $bitmapDescriptor");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de Rider'),
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: GoogleMap(
            zoomControlsEnabled: false,
            markers: _markers,
            circles: {circle},
            initialCameraPosition: CameraPosition(
              zoom: 15.0,
              target: test1,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: isLoading,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Text("Recherche de rider en cours"),
              ])),
        ),
        if (rider.length > 0)
          Visibility(
            visible: !isLoading,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Choisir votre rider"),
                ])),
          ),
        Expanded(
          flex: 1,
          child: rider.length > 0
              ? ListView.builder(
                  itemCount: rider.length,
                  itemBuilder: (context, index) {
                    // Get the current item from the list
                    final item = rider[index];
                    return 
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(16,0,16,4),
                    //   child: RideeCard(
                    //   leftImage:item['profilePicture'],
                    //   title: item['vehicleLicencePlate'],
                    //   subtitle: item['title'],
                    //   // rightImage: 'assets/images/ridee_moto.png',
                    //   prix: 20000,
                    // ));
                    // rideeCard eto
                    // /* 
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: ListTile(
                        leading: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.width * 0.12,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF00AD9C),
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                                item['profilePicture']),
                          ),
                        ),
                        title: Text(
                          item['vehicleLicencePlate'] as String,
                        ),
                        // Use subtitle to show a short description below the title
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.025,
                            ),
                            Text(
                              '${item['title'] as String}, vous prends',
                            ),
                            // Use Row to show a number and another text at the side of it
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.025,
                            ),
                            Text(
                              '${item['moyenneNote'] as double} | ${item['nombreLivraisonsArrived']} course(s) ces 7 derniers jours.',
                            ),
                          ],
                        ),
                        // Use onTap to execute a function when user taps on an item
                        onTap: () {
                          // Print out some information about current item
                          print('You tapped on ${item['title']}');
                          // Update selectedIndex using setState
                          setState(() {
                            selectedrider = item;
                            selectedIndex = index;
                          });
                        },
                        // Use tileColor to change color based on selectedIndex
                        tileColor: selectedIndex == index
                            ? Color(0xFF00AD9C)
                            : Colors.transparent,
                      ),
                    );
                    //*/
                  },
                )
              : isLoading
                  ? Center(
                      child: Text("Un instant...",
                          style: TextStyle(
                              fontSize: 14, color: scheme.onSurfaceVariant)))
                  : Center(
                      child: Text("Aucun rider disponible pour le moment",
                          style: TextStyle(fontSize: 14, color: scheme.error))),
        ),
        Expanded(
          flex: 0,
          //Button that redirect to another screen with the informations
          child: ElevatedButton(
            onPressed: rider.length <= 0 || selectedIndex == -1
                ? null
                : isWaitASec
                    ? null
                    : _handleButtonClick,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                  double.infinity, 75), // Adjusted width to occupy full width
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
                    .zero, // This makes the button corners not rounded
              ),
            ),
            child:
                Text(isWaitASec ? 'En cours de traitement ...' : 'Confirmer'),
          ),
        ),
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75.0),
        child: FloatingActionButton(
          backgroundColor: scheme.secondaryContainer,
          foregroundColor: scheme.onSecondaryContainer,
          child: Icon(Icons.refresh),
          onPressed: () async {
            print("refresh");
            await rechercher();
          },
        ),
      ),
    );
  }
}
