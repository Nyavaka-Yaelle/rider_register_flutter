import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:rider_register/models/user.dart';
import 'package:rider_register/repository/commande_repository.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/screens/home_finally_page/Accueille.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'package:rider_register/screens/destination4_screen.dart';
import 'package:rider_register/screens/maplive_redirector_screen.dart';
import 'package:rider_register/screens/mydelivery_screen.dart';
import 'package:rider_register/screens/myprofile_screen.dart';

import 'dart:typed_data';
import 'dart:ui';

import '../main.dart';
import '../models/commande.dart';
import '../models/position.dart';
import '../repository/appareiluser_repository.dart';
import '../repository/position_repository.dart';
import '../repository/user_repository.dart';

// Define the first screen as a stateful widget
class RechooseriderScreen extends StatefulWidget {
  final String idLivraison;
  final String idRider;

  RechooseriderScreen({required this.idLivraison, required this.idRider});

  @override
  _RechooseriderScreenState createState() => _RechooseriderScreenState();
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
class _RechooseriderScreenState extends State<RechooseriderScreen> {
  // Define a future that waits for x seconds and returns true
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  String totalDistance = 'No route';
  PositionRepository positionRepository = new PositionRepository();
  UserRepository userRepository = new UserRepository();
  LivraisonRepository livraisonRepository = new LivraisonRepository();
  CommandeRepository commandeRepository = new CommandeRepository();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Uint8List? markerIcon;
  Circle circle = Circle(circleId: CircleId('myCircle'));
  BitmapDescriptor? bitmapDescriptor;
  AppareilUserRepository appareilUserRepository = new AppareilUserRepository();
  bool isLoading = false;
  bool isWaitASec = false;

  // Define a variable to store the index of the selected item
  int selectedIndex = -1;
  dynamic selectedrider = {};
  List<Position?> riderpositions = [];
  dynamic rider = [];
  Livraison? livraisontoshow;
  String? type;
  Commande? commande;
  double money = 0;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Delay for 500ms

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Accueille()),
          );
        });
      }
      if (_currentIndex == 1) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
          // );
        });
      }
      if (_currentIndex == 4) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
          // );
        });
      }
      print('index: $_currentIndex');
    });
  }

  Future<void> rechercher() async {
    rider = [];
    setState(() {
      isLoading = true;
    });
    livraisontoshow =
        await livraisonRepository.getLivraisonById(widget.idLivraison);
    if (livraisontoshow!.listnotepackee!.isNotEmpty) {
      type = "packee";
      test1 = LatLng(double.parse(livraisontoshow!.latitudeArrivee!),
          double.parse(livraisontoshow!.longitudeArrivee!));
    }
    if (livraisontoshow!.idcommande!.isNotEmpty) {
      type = "foodee";
      commande = await commandeRepository
          .getCommandeById(livraisontoshow!.idcommande!);
      test1 = LatLng(double.parse(livraisontoshow!.latitudeDepart!),
          double.parse(livraisontoshow!.longitudeDepart!));
    } else {
      type = "ridee";
      test1 = LatLng(double.parse(livraisontoshow!.latitudeDepart!),
          double.parse(livraisontoshow!.longitudeDepart!));
    }
    if (type == "packee") {
      //loop through context.read<DeliveryData>().notePackee!
      for (int i = 0; i < livraisontoshow!.listpricepackee!.length; i++) {
        money = money + livraisontoshow!.listpricepackee![i];
      }
    }
    if (type == "foodee") {
      for (int i = 0; i < commande!.prix!.length; i++) {
        money = money + (commande!.prix![i] * commande!.quantites![i]);
      }
    }
    if (type == "ridee") {
      money = -1.0;
    }
          await positionRepository.updateposition(money);
    riderpositions = await positionRepository.getriderNearTheDeliveryLocation(
        test1.latitude.toString(), test1.longitude.toString(), money);
    markerIcon = await getBytesFromAsset('assets/logo/Motar.png', 64);
    bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
    dynamic riderrecherche = [];

    if (riderpositions != null) {
      print("riderpositions.length ${riderpositions.length}");
    } else {
      print("riderpositions.length is null");
    }
    for (int i = 0; i < riderpositions.length; i++) {
      print("riderpositions[i] ${riderpositions[i]}");
      User? user = await userRepository.getUserById(riderpositions[i]!.iduser!);
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
      Rider? riderdetail =
          await userRepository.getRiderByUserById(riderpositions[i]!.iduser!);
      dynamic ridertoshow = {
        'nombreLivraisonsArrived': riderdetail!.nombreLivraisonsArrived,
        'moyenneNote': riderdetail.moyenneNote,
        'vehicleLicencePlate': riderdetail.vehicleLicencePlate,
        'profilePicture': riderdetail.profilePicture,
        'title': riderdetail!.displayName,
        'id': riderpositions[i]!.iduser,
        'position': LatLng(double.parse(riderpositions[i]!.latitude!),
            double.parse(riderpositions[i]!.longitude!)),
        'description': 'You are the one and only',
        'number': '5',
        'anothertext': '2-4 personnes',
      };
      print(" Fix bug " + riderpositions[i]!.iduser.toString());
      if (widget.idRider != riderpositions[i]!.iduser) {
        rider.add(ridertoshow);
      }
      //check if the rider is null
      //if (rider) print("rider " + rider.toString());
    }

    //set marker for depart and arrivee
    Marker markerDepart = Marker(
      markerId: MarkerId('Vous'),
      position: test1,
      infoWindow: InfoWindow(title: 'Vous'),
    );

    //add marker to map

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
      print("idLivraison " + widget.idLivraison);
      await rechercher();

      // _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      //   if (_counter > 6) {
      //     _timer.cancel();
      //     return;
      //   }
      //    await rechercher();
      //   _counter++;
      // });
    });
    circle = circle.copyWith(
      centerParam: test1, // Set circle center as same as marker position
      radiusParam: 2000, // Set circle radius as 1km (1000 meters)
      fillColorParam: Color(0xFF00AD9C)!.withOpacity(
          0.5), // Set circle fill color as purple with some transparency
      strokeColorParam: Color(
          0xFF00AD9C), // Set circle stroke color as purple with some transparency
    );
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is removed from the tree
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("bitmapDescriptor: $bitmapDescriptor");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destination 3'),
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
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Text("La recherche de rider(s) est en cours de chargement."),
          ]),
        ),
        Visibility(
          visible: !isLoading,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Choisir votre rider"),
          ]),
        ),
        Expanded(
          flex: 1,
          child: rider != null
              ? ListView.builder(
                  itemCount: rider.length,
                  itemBuilder: (context, index) {
                    // Get the current item from the list
                    final item = rider[index];
                    return Padding(
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
                  },
                )
              : Center(child: Text("Aucun rider disponible")),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  await livraisonRepository.removeFieldFromDocument(
                      widget.idLivraison, "statut");
                  //Future delayed 500 ms

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Accueille()),
                        (route) => false);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                child: Text('Annuler'),
              ),
            ),
            if (selectedIndex != -1)
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () async {
                    List<String> tokens = [];

                    String? token = await appareilUserRepository
                        .getTokenById(selectedrider!['id']);
                    tokens.add(token!);
                    appareilUserRepository.sendNotif(
                        "livraison en attente",
                        "livraison pres de chez vous",
                        widget.idLivraison,
                        tokens);
                    await livraisonRepository.updateLivraisonRider(
                        widget.idLivraison, selectedrider!['id']);
                    await livraisonRepository.updateLivraisonStatut(
                        widget.idLivraison, "Created");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapliveredirectorScreen(
                            idLivraison: widget.idLivraison,
                            type: type!,
                          ),
                        ),
                        (route) => false);
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 50)),
                  ),
                  child: Text('Confirmer'),
                ),
              ),
          ],
        ),
      ]),     floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () async {
                print("refresh");
                await rechercher();
              },
            ),
          ), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          )
        ],
      ),
    );
  }
}
