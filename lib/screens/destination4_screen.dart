import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/models/commande.dart';
import 'package:rider_register/models/config.dart';
import 'package:rider_register/repository/appareiluser_repository.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'package:rider_register/screens/maplive_redirector_screen.dart';
import 'package:rider_register/screens/newmaplive.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';

import 'package:rider_register/theme/custom_button_style.dart';
import 'package:rider_register/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:rider_register/widgets/custom_icon_button.dart';
import 'package:rider_register/widgets/ridee/your_position_card.dart';
import 'package:rider_register/widgets/wallet/card_rider_contact.dart';
import 'package:rider_register/widgets/wallet/label_dark_wallet.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';

import '../main.dart';
import '../models/livraison.dart';
import '../models/restaurant.dart';
import '../repository/commande_repository.dart';
import '../repository/position_repository.dart';
import '../repository/config_repository.dart';

// Define the first screen as a stateful widget
class Destination4Screen extends StatefulWidget {
  final dynamic rider;
  final LatLng depart;
  final String type;
  final Commande commande;
  Destination4Screen(
      {required this.rider,
      required this.depart,
      required this.type,
      required this.commande});

  @override
  _Destination4ScreenState createState() => _Destination4ScreenState();
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
class _Destination4ScreenState extends State<Destination4Screen> {
  // Define a future that waits for x seconds and returns true
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  String totalDistance = 'No route';
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  Config foodee = Config();
  Config packee = Config();
  Config ridee = Config();
  Config caree = Config();

  Config global = Config();

  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Uint8List? markerIcon;
  Circle circle = Circle(circleId: CircleId('myCircle'));
  BitmapDescriptor? bitmapDescriptor;
  UserRepository userRepository = new UserRepository();
  ConfigRepository configRepository = new ConfigRepository();

  LivraisonRepository livraisonRepository = new LivraisonRepository();
  AppareilUserRepository appareilUserRepository = new AppareilUserRepository();
  CommandeRepository _commandeRepository = CommandeRepository();
  PositionRepository _positionRepository = PositionRepository();
  // Define a variable to store the index of the selected item
  int selectedIndex = -1;
  double prixtoshow = 0;
  double prix = 0;
  bool isWaitASec = false;

//
  User? user;
  dynamic departLocation = new LatLng(0, 0);
  dynamic deliveryLocation = new LatLng(0, 0);
  dynamic departaddress = " ";
  dynamic deliveryadress = " ";
  List<LatLng> multipoints = [];
  dynamic multipointAddress = [];
  List<String> multipointAddressList = [];
  List<String> listnotepackee = [];
  List<double> listpricepackee = [];
  // double prix = 0;
  double commission = 0;
  // double prixtoshow = 0;
  double kilometrage = 0.0;
  double prixkm = 0.0; // en ariar
  double prixenplus = 0.0;

  final rider = [
    {},
  ];
  void _showBottomSheet() {
    showCustomBottomSheet(
      height:  375.v,
      context,
      children: [
        SizedBox(height: 12.v),
        YourPositionCard(
          position: widget.type == "foodee"
              ? context.read<DeliveryData>().orderingRestaurant!.address
              : (widget.type == "ridee" || widget.type == "caree")
                  ? context.read<DeliveryData>().departAddressRidee!
                  : widget.type == "packee"
                      ? context.read<DeliveryData>().multipointAddress![0]
                          ["address"]
                      : 'Unknown widget type',
          positiondepart: widget.type == "foodee"
              ? context.read<DeliveryData>().departAddressFoodee!
              : (widget.type == "ridee" || widget.type == "caree")
                  ? context.read<DeliveryData>().multipointAddress![0]
                      ["address"]
                  : widget.type == "packee"
                      ? context.read<DeliveryData>().departAddressRidee!
                      : 'Unknown widget type',
          right: LabelDarkWallet(text: "${prix + prixtoshow} Ar" as String),
        ),
        SizedBox(height: 8.h),
        CardRiderContact(
          motor: widget.rider['vehicleLicencePlate'] as String,
          rider: widget.rider['title'],
          riderImg: widget.rider['profilePicture'],
          star: (widget.rider['moyenneNote'] as double).round(),
        ),
        SizedBox(height: 50.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomElevatedButton(
              width: 156.v,
              height: 40.h,
              text: "Annuler",
              onPressed: () {},
              buttonStyle: CustomButtonStyles.outlined,
              buttonTextStyle: CustomTextStyles.titleSmallTeal800,
            ),
            CustomElevatedButton(
              width: 156.v,
              height: 40.h,
              //disabled stile for the button
              buttonStyle: ElevatedButton.styleFrom(
                primary: isWaitASec
                    ? Colors.grey
                    : null, // Change color based on state
              ),
              text: "Commander",
              onPressed: isWaitASec
                  ? null
                  : () async {
                      setState(() {
                        isWaitASec = true;
                      });
                      _showBottomSheet();
                      print("prixtttt is $isWaitASec");

                      String idLivraison = "";
                      int prixtoint = 0;
                      // dynamic distancetomap =
                      //     await _positionRepository.getInfoTrajet(
                      //         departLocation!.latitude!.toString(),
                      //         departLocation!.longitude!.toString(),
                      //         multipoints[multipoints.length - 1]
                      //             .latitude
                      //             .toString(),
                      //         multipoints[multipoints.length - 1]
                      //             .longitude
                      //             .toString());
                      //cacule price based on distance from depart to multipoint[0] to 1 and so on

                      //prixtoint = ((prix / 100).round() * 100).toInt();
                      List<String> tokens = [];
                      print(widget.rider["id"] + "id rider");

                      //Future deelay
                      if (widget.type == "ridee" || widget.type == "caree") {
                        idLivraison = await livraisonRepository.addLivraison(
                            Livraison(
                                dateenregistrement: Timestamp.now(),
                                description: context
                                    .read<DeliveryData>()
                                    .noteRidee
                                    .toString(),
                                //q: string to int flutter?
                                //a: int.parse(_textControllerPoids.text),
                                poids: 0,
                                statut: "Created",
                                iduser: user!.uid,
                                idrider: widget.rider["id"],
                                prix: prix,
                                latitudeDepart:
                                    departLocation!.latitude.toString(),
                                longitudeDepart:
                                    departLocation!.longitude.toString(),
                                latitudeArrivee:
                                    deliveryLocation!.latitude.toString(),
                                longitudeArrivee:
                                    deliveryLocation!.longitude.toString(),
                                multipoints: multipoints,
                                idcommande: null,
                                multipointsAddress: multipointAddressList,
                                namePlaceDepart: departaddress,
                                listnotepackee: null,
                                listpricepackee: null,
                                namePlaceArrivee: deliveryadress));
                        String? token = await appareilUserRepository
                            .getTokenById(widget.rider["id"]);
                        tokens.add(token!);
                        appareilUserRepository.sendNotif("Livraison en attente",
                            "Livraison près de chez vous", idLivraison, tokens);
                      }
                      if (widget.type == "packee") {
                        print("prix packee  " + prix.toString());

                        idLivraison = await livraisonRepository
                            .addLivraisonPackee(Livraison(
                                dateenregistrement: Timestamp.now(),
                                description: context
                                    .read<DeliveryData>()
                                    .noteRidee
                                    .toString(),
                                //q: string to int flutter?
                                //a: int.parse(_textControllerPoids.text),
                                poids: 0,
                                statut: "Created",
                                iduser: user!.uid,
                                idrider: widget.rider["id"],
                                latitudeDepart: "null",
                                longitudeDepart: "null",
                                prix: prix,
                                latitudeArrivee:
                                    departLocation!.latitude.toString(),
                                longitudeArrivee:
                                    departLocation!.longitude.toString(),
                                multipoints: multipoints,
                                multipointsAddress: multipointAddressList,
                                namePlaceDepart: "null",
                                idcommande: null,
                                listnotepackee: listnotepackee,
                                listpricepackee: listpricepackee,
                                namePlaceArrivee: departaddress));
                        String? token = await appareilUserRepository
                            .getTokenById(widget.rider["id"]);
                        tokens.add(token!);
                        appareilUserRepository.sendNotif("Livraison en attente",
                            "Livraison près de chez vous", idLivraison, tokens);
                      }
                      if (widget.type == "foodee") {
                        String idcommande = await _commandeRepository
                            .insertCommande(widget.commande);
                        Restaurant r =
                            context.read<DeliveryData>().orderingRestaurant!;

                        idLivraison =
                            await livraisonRepository.addLivraisonWithCommande(
                                Livraison(
                                    dateenregistrement:
                                        widget.commande.dateenregistrement,
                                    description: context
                                        .read<DeliveryData>()
                                        .noteRidee
                                        .toString(),
                                    poids: 0,
                                    statut: "Created",
                                    prix: prix,
                                    iduser: widget.commande.iduser,
                                    idrider: widget.rider["id"],
                                    latitudeDepart:
                                        departLocation!.latitude.toString(),
                                    longitudeDepart:
                                        departLocation!.longitude.toString(),
                                    latitudeArrivee:
                                        multipoints[0].latitude.toString(),
                                    longitudeArrivee:
                                        multipoints[0].longitude.toString(),
                                    listnotepackee: null,
                                    idcommande: null,
                                    listpricepackee: null,
                                    multipoints: multipoints,
                                    multipointsAddress: multipointAddressList,
                                    namePlaceDepart: departaddress,
                                    namePlaceArrivee: "null"),
                                idcommande);
                        String? token =
                            await appareilUserRepository.getTokenById(r.id);
                        tokens.add(token!);
                        appareilUserRepository.sendNotif("Commande en attente",
                            "Nouveau commande chez vous", idLivraison, tokens);
                        appareilUserRepository.insertNotifResto(
                            idcommande,
                            "Commande en attente",
                            "Nouveau commande chez vous");
                      }

                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          isWaitASec = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MapliveredirectorScreen(
                                    type: widget.type,
                                    idLivraison: idLivraison,
                                  )),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      markerIcon = await getBytesFromAsset('assets/logo/Motar.png', 64);
      foodee = (await configRepository.getConfigById("foodee"));
      ridee = (await configRepository.getConfigById("ridee"));
      caree = (await configRepository.getConfigById(
          "caree")); // need to change this to caree when available

      packee = (await configRepository.getConfigById("packee"));
      if (widget.type != "caree") {
        global = (await configRepository.getConfigById("global"));
      } else {
        global = (await configRepository.getConfigById("globalCaree"));
      }
      print(global.kmInitialCourse);
      bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
      print("the rider is ${widget.rider["position"]}");
      //set marker for depart and arrivee
      Marker markerDepart = Marker(
        markerId: MarkerId('Vous'),
        position: widget.depart,
        infoWindow: InfoWindow(title: 'Vous'),
      );
      Marker markerArrivee = Marker(
        markerId: MarkerId(widget.rider["title"]),
        position: widget.rider["position"] as LatLng,
        infoWindow: InfoWindow(title: widget.rider["title"]),
        icon: bitmapDescriptor!,
      );
      //add marker to map
      user = userRepository.getCurrentUser();
      //   departLocation = new LatLng(0, 0);
      //    deliveryLocation = new LatLng(0, 0);
      //    departaddress = " ";
      //    deliveryadress = " ";
      //  multipoints = [];
      //    multipointAddress = [];
      //    multipointAddressList = [];
      //  listnotepackee = [];
      //    listpricepackee = [];
      //   // double prix = 0;
      //   commission = 0;
      // double prixtoshow = 0;
      kilometrage = global.kmInitialCourse ?? 0.0;
      prixkm = global.prixInitialCourse ?? 0.0; // en ariar
      prixenplus = global.prixParKm ?? 0.0;
      setState(() {
        _markers!.add(markerDepart);
        _markers!.add(markerArrivee);
      });
    });
    // delayed 1 second then show  _showBottomSheet()
    Future.delayed(Duration(seconds: 3), () {
      _showBottomSheet();
    });

    circle = circle.copyWith(
      centerParam:
          widget.depart, // Set circle center as same as marker position
      radiusParam: 2000, // Set circle radius as 1km (1000 meters)
      fillColorParam: Color(0xFF00AD9C)!.withOpacity(
          0.5), // Set circle fill color as purple with some transparency
      strokeColorParam: Color(
          0xFF00AD9C), // Set circle stroke color as purple with some transparency
    );
    super.initState();
  }

  //function that calculate the price of the delivery depending on the distance from depart to multipoint 0 to multipoint 1 and so on and the distance from the last multipoint to the delivery point
  double calcultotaldistance(List<LatLng> multipoint) {
    //calcul the distance from depart to multipoint 0 and from multipoint 0 to multipoint 1 and so on
    double distance = 0;
    dynamic distancetomap = {};
    for (int i = 0; i < multipoint.length - 1; i++) {
      distancetomap = _positionRepository
          .getInfoTrajet(
              multipoint[i].latitude.toString(),
              multipoint[i].longitude.toString(),
              multipoint[i + 1].latitude.toString(),
              multipoint[i + 1].longitude.toString())
          .then((value) => {
                distance = distance +
                    value['rows'][0]['elements'][0]['distance']['value'] / 1000
              });
    }
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    // User? user = userRepository.getCurrentUser();
    // dynamic departLocation = new LatLng(0, 0);
    // dynamic deliveryLocation = new LatLng(0, 0);
    // dynamic departaddress = " ";
    // dynamic deliveryadress = " ";
    // List<LatLng> multipoints = [];
    // dynamic multipointAddress = [];
    // List<String> multipointAddressList = [];
    // List<String> listnotepackee = [];
    // List<double> listpricepackee = [];
    // // double prix = 0;
    // double commission = 0;
    // // double prixtoshow = 0;
    // double kilometrage = global.kmInitialCourse ?? 0.0;
    // double prixkm = global.prixInitialCourse ?? 0.0; // en ariar
    // double prixenplus = global.prixParKm ?? 0.0;
    print("config global " +
        kilometrage.toString() +
        " " +
        prixkm.toString() +
        " " +
        prixenplus.toString() +
        " " +
        foodee.commissionApp.toString() +
        " ");

    print(widget.rider["id"] + "id rider");

    if (widget.type == "ridee") {
      departLocation = context.watch<DeliveryData>().departLocationRidee;
      deliveryLocation = context.watch<DeliveryData>().deliveryLocationRidee;
      departaddress = context.watch<DeliveryData>().departAddressRidee;
      deliveryadress = context.watch<DeliveryData>().deliveryAddressRidee;
      multipoints = context.watch<DeliveryData>().multipoint!;
      commission = ridee.commissionApp ?? 0.0;
      print(commission);
      multipointAddress = context.watch<DeliveryData>().multipointAddress;
      if (multipointAddress != null) {
        multipointAddress.forEach((element) {
          multipointAddressList.add(element['address']);
        });
      }

      print("prix2 is $prix");
      //calculate the price of the delivery by using the distance between depart and delivery if the distance is less than 5km the price is 5000ar else the price is 5000ar + 1000ar for each km
      // prix = context.watch<DeliveryData>().distance! < 5
      //     ? 5000
      //     : 5000 + (context.watch<DeliveryData>().distance! - 5) * 1000;
    }
    if (widget.type == "caree") {
      departLocation = context.watch<DeliveryData>().departLocationRidee;
      deliveryLocation = context.watch<DeliveryData>().deliveryLocationRidee;
      departaddress = context.watch<DeliveryData>().departAddressRidee;
      deliveryadress = context.watch<DeliveryData>().deliveryAddressRidee;
      multipoints = context.watch<DeliveryData>().multipoint!;
      commission = caree.commissionApp ?? 0.0;
      print(commission);
      multipointAddress = context.watch<DeliveryData>().multipointAddress;
      if (multipointAddress != null) {
        multipointAddress.forEach((element) {
          multipointAddressList.add(element['address']);
        });
      }

      print("prix2 is $prix");
      //calculate the price of the delivery by using the distance between depart and delivery if the distance is less than 5km the price is 5000ar else the price is 5000ar + 1000ar for each km
      // prix = context.watch<DeliveryData>().distance! < 5
      //     ? 5000
      //     : 5000 + (context.watch<DeliveryData>().distance! - 5) * 1000;
    }
    if (widget.type == "packee") {
      departLocation = context.watch<DeliveryData>().departLocationRidee;
      deliveryLocation = context.watch<DeliveryData>().deliveryLocationRidee;
      departaddress = context.watch<DeliveryData>().departAddressRidee;
      deliveryadress = context.watch<DeliveryData>().deliveryAddressRidee;
      multipoints = context.watch<DeliveryData>().multipoint!;
      multipointAddress = context.watch<DeliveryData>().multipointAddress;
      commission = packee.commissionApp ?? 0.0;

      if (multipointAddress != null) {
        multipointAddress.forEach((element) {
          multipointAddressList.add(element['address']);
        });
      }
      //convert context.watch<DeliveryData>().notePackee of dynamic to list of string
      context.watch<DeliveryData>().notePackee!.forEach((element) {
        listnotepackee.add(element['note']);
      });
      //convert context.watch<DeliveryData>().pricePackee of dynamic to list of double
      context.watch<DeliveryData>().notePackee!.forEach((element) {
        listpricepackee.add(double.parse(element['price']));

        prixtoshow = prixtoshow + double.parse(element['price']);
      });
    }
    if (widget.type == "foodee") {
      Restaurant r = context.read<DeliveryData>().orderingRestaurant!;
      commission = foodee.commissionApp ?? 0.0;
      departLocation = widget.depart; //Restaurant location
      departaddress = r.name;
      multipoints.add(LatLng(
          context.read<DeliveryData>().departLocationFoodee!.latitude,
          context.read<DeliveryData>().departLocationFoodee!.longitude));
      //convert restaurant location to string and add to multipointAddressList
      multipointAddressList
          .add(context.read<DeliveryData>().departAddressFoodee!);
      prixtoshow =
          prixtoshow + context.read<DeliveryData>().cartFoodieTotalLocal;
    }
    List<LatLng> listmultipointstemp = [];
    listmultipointstemp.add(departLocation!);
    listmultipointstemp.addAll(multipoints);
    double distance = calcultotaldistance(listmultipointstemp);

    prix = distance < kilometrage
        ? prixkm
        : prixkm + (distance - kilometrage) * prixenplus;
    print("prix is $prix");
    prix = prix + commission;
    prix = ((prix / 100).round() * 100);

    //multipointsAddress is a list of dynamic that have an address attribute , we need to convert it to a list of string

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif de la Commande'),
      ),
      body: Column(children: [
        Expanded(
          flex: 3,
          child: GoogleMap(
            zoomControlsEnabled: false,
            markers: _markers,
            circles: {circle},
            initialCameraPosition: CameraPosition(
              zoom: 13.0,
              target: widget.depart,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
          ),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // Expanded(
        //   flex: 1,
        //   child: ListView.builder(
        //     itemCount: rider.length,
        //     itemBuilder: (context, index) {
        //       // Get the current item from the list
        //       final item = rider[index];
        //       return ListTile(
        //         // Use leading to show an icon on the left
        //         leading: Container(
        //           width: MediaQuery.of(context).size.width * 0.12,
        //           height: MediaQuery.of(context).size.width * 0.12,
        //           decoration: BoxDecoration(
        //             border: Border.all(
        //               color: Color(0xFF00AD9C),
        //               style: BorderStyle.solid,
        //               width: 2,
        //             ),
        //             borderRadius: BorderRadius.circular(100),
        //           ),
        //           child: CircleAvatar(
        //             radius: 32, // Adjust the radius as needed
        //             backgroundColor: Colors
        //                 .transparent, // Add a transparent background to remove the default white background
        //             backgroundImage: CachedNetworkImageProvider(
        //                 widget.rider['profilePicture']),
        //           ),
        //         ),
        //         title: Text(
        //           widget.rider['vehicleLicencePlate'] as String,
        //         ),
        //         // Use subtitle to show a short description below the title
        //         subtitle: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             SizedBox(
        //               height: MediaQuery.of(context).size.width * 0.025,
        //             ),
        //             Text(
        //               '${widget.rider['title'] as String}, vous prends',
        //             ),
        //             // Use Row to show a number and another text at the side of it
        //             SizedBox(
        //               height: MediaQuery.of(context).size.width * 0.025,
        //             ),
        //             Text(
        //               '${widget.rider['moyenneNote'] as double} | ${widget.rider['nombreLivraisonsArrived']} course(s) ces 7 derniers jours.',
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // Expanded(
        //   flex: 1,
        //   child: Row(
        //     children: [
        //       //Button that redirect to another screen with the informations
        //       Expanded(
        //         flex: 1,
        //         child: ElevatedButton(
        //           onPressed: () {
        //             //Add your logic here
        //           },
        //           style: ButtonStyle(
        //             minimumSize: MaterialStateProperty.all(
        //               Size(double.infinity, 50),
        //             ),
        //             backgroundColor: MaterialStateProperty.all(scheme.onPrimary),
        //             shape: MaterialStateProperty.all(StadiumBorder(
        //               //set border shape here
        //               side: BorderSide(
        //                   color: Colors.grey), //set border color here
        //             )),
        //           ),
        //           child: Text('Appeler', style: TextStyle(color: Colors.grey)),
        //         ),
        //       ),
        //       //New button with transparent background
        //       Expanded(
        //         flex: 1,
        //         child: ElevatedButton(
        //           onPressed: () {
        //             //Add your logic here
        //           },
        //           style: ButtonStyle(
        //             minimumSize: MaterialStateProperty.all(
        //               Size(double.infinity, 50),
        //             ),
        //             backgroundColor: MaterialStateProperty.all(scheme.onPrimary),
        //             shape: MaterialStateProperty.all(StadiumBorder(
        //               //set border shape here
        //               side: BorderSide(
        //                   color: Colors.grey), //set border color here
        //             )),
        //           ),
        //           child:
        //               Text('Messagerie', style: TextStyle(color: Colors.grey)),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(
        //   flex: 1,
        //   child: ListTile(
        //     // Use leading to show an icon on the left
        //     leading: Container(
        //       // Use BoxDecoration to add a border around the image

        //       child: ClipRRect(
        //         // Set circular radius as half of image size (64/2 = 32)
        //         child: Image(
        //           image: AssetImage(
        //               'assets/images/logo.png'), // Load an asset image
        //           width: 32,
        //           height: 32,
        //         ),
        //       ),
        //     ),
        //     // Use title to show a bold title
        //     title: Text(
        //       "Point de départ",
        //       style: TextStyle(fontSize: 20),
        //     ),
        //     // Use subtitle to show a short description below the title
        //     subtitle: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         //if widget.type == "foodee" then show the foodee address else show the ridee address
        //         widget.type == "foodee"
        //             ? Text(
        //                 context
        //                     .read<DeliveryData>()
        //                     .orderingRestaurant!
        //                     .address,
        //                 style: TextStyle(
        //                     fontSize: 20, fontWeight: FontWeight.bold))
        //             : (widget.type == "ridee" || widget.type == "caree")
        //                 ? Text(context.read<DeliveryData>().departAddressRidee!,
        //                     style: TextStyle(
        //                         fontSize: 20, fontWeight: FontWeight.bold))
        //                 : widget.type == "packee"
        //                     ? Text(
        //                         context
        //                             .read<DeliveryData>()
        //                             .multipointAddress![0]["address"],
        //                         style: TextStyle(
        //                             fontSize: 20, fontWeight: FontWeight.bold))
        //                     : Text('Unknown widget type',
        //                         style: TextStyle(
        //                             fontSize: 20, fontWeight: FontWeight.bold)),
        //       ],
        //     ),
        //   ),
        // ),
//         Expanded(
//           flex: 1,
//           child: ListTile(
//             // Use leading to show an icon on the left
//             leading: Container(
//               child: ClipRRect(
// // Set circular radius as half of image size (64/2 = 32)
//                 child: Image(
//                   image: AssetImage(
//                       'assets/images/logo.png'), // Load an asset image
//                   width: 32,
//                   height: 32,
//                 ),
//               ),
//             ),
//             // Use title to show a bold title
//             title: Text(
//               "Point d'arrivée",
//               style: TextStyle(fontSize: 20),
//             ),
//             // Use subtitle to show a short description below the title
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Check widget.type and display the corresponding address
//                 widget.type == "foodee"
//                     ? Text(context.read<DeliveryData>().departAddressFoodee!,
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold))
//                     : (widget.type == "ridee" || widget.type == "caree")
//                         ? Text(
//                             context.read<DeliveryData>().multipointAddress![0]
//                                 ["address"],
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold))
//                         : widget.type == "packee"
//                             ? Text(
//                                 context
//                                     .read<DeliveryData>()
//                                     .departAddressRidee!,
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold))
//                             : Text('Unknown widget type',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ),
        // Expanded(
        //   flex: 1,
        //   child:
        //       Row(// Use a row to display the icon, text and button horizontally
        //           children: [
        //     SizedBox(width: 25),
        //     Image(
        //       image: AssetImage("assets/images/identification-documents.png"),
        //       width: 50,
        //       height: 50,
        //     ),
        //     SizedBox(width: 10),
        //     Text("Total" as String,
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        //     Spacer(),
        //     Text("${prix + prixtoshow} Ar" as String,
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 20,
        //             color: Color(0xFF00AD9C))),
        //     SizedBox(width: 10),
        //   ]),
        // ),
        // Expanded(
        //   flex: 0,
        //   child: Row(
        //     children: [
        //       //Button that redirect to another screen with the informations
        //       Expanded(
        //         child: ElevatedButton(
        //           onPressed: isWaitASec
        //               ? null
        //               : () async {
        //                   setState(() {
        //                     isWaitASec = true;
        //                   });
        //                   String idLivraison = "";
        //                   int prixtoint = 0;
        //                   // dynamic distancetomap =
        //                   //     await _positionRepository.getInfoTrajet(
        //                   //         departLocation!.latitude!.toString(),
        //                   //         departLocation!.longitude!.toString(),
        //                   //         multipoints[multipoints.length - 1]
        //                   //             .latitude
        //                   //             .toString(),
        //                   //         multipoints[multipoints.length - 1]
        //                   //             .longitude
        //                   //             .toString());
        //                   //cacule price based on distance from depart to multipoint[0] to 1 and so on

        //                   //prixtoint = ((prix / 100).round() * 100).toInt();
        //                   List<String> tokens = [];
        //                   print(widget.rider["id"] + "id rider");

        //                   //Future deelay
        //                   if (widget.type == "ridee" ||
        //                       widget.type == "caree") {
        //                     idLivraison = await livraisonRepository
        //                         .addLivraison(Livraison(
        //                             dateenregistrement: Timestamp.now(),
        //                             description: context
        //                                 .read<DeliveryData>()
        //                                 .noteRidee
        //                                 .toString(),
        //                             //q: string to int flutter?
        //                             //a: int.parse(_textControllerPoids.text),
        //                             poids: 0,
        //                             statut: "Created",
        //                             iduser: user!.uid,
        //                             idrider: widget.rider["id"],
        //                             prix: prix,
        //                             latitudeDepart:
        //                                 departLocation!.latitude.toString(),
        //                             longitudeDepart:
        //                                 departLocation!.longitude.toString(),
        //                             latitudeArrivee:
        //                                 deliveryLocation!.latitude.toString(),
        //                             longitudeArrivee:
        //                                 deliveryLocation!.longitude.toString(),
        //                             multipoints: multipoints,
        //                             idcommande: null,
        //                             multipointsAddress: multipointAddressList,
        //                             namePlaceDepart: departaddress,
        //                             listnotepackee: null,
        //                             listpricepackee: null,
        //                             namePlaceArrivee: deliveryadress));
        //                     String? token = await appareilUserRepository
        //                         .getTokenById(widget.rider["id"]);
        //                     tokens.add(token!);
        //                     appareilUserRepository.sendNotif(
        //                         "Livraison en attente",
        //                         "Livraison près de chez vous",
        //                         idLivraison,
        //                         tokens);
        //                   }
        //                   if (widget.type == "packee") {
        //                     print("prix packee  " + prix.toString());

        //                     idLivraison = await livraisonRepository
        //                         .addLivraisonPackee(Livraison(
        //                             dateenregistrement: Timestamp.now(),
        //                             description: context
        //                                 .read<DeliveryData>()
        //                                 .noteRidee
        //                                 .toString(),
        //                             //q: string to int flutter?
        //                             //a: int.parse(_textControllerPoids.text),
        //                             poids: 0,
        //                             statut: "Created",
        //                             iduser: user!.uid,
        //                             idrider: widget.rider["id"],
        //                             latitudeDepart: "null",
        //                             longitudeDepart: "null",
        //                             prix: prix,
        //                             latitudeArrivee:
        //                                 departLocation!.latitude.toString(),
        //                             longitudeArrivee:
        //                                 departLocation!.longitude.toString(),
        //                             multipoints: multipoints,
        //                             multipointsAddress: multipointAddressList,
        //                             namePlaceDepart: "null",
        //                             idcommande: null,
        //                             listnotepackee: listnotepackee,
        //                             listpricepackee: listpricepackee,
        //                             namePlaceArrivee: departaddress));
        //                     String? token = await appareilUserRepository
        //                         .getTokenById(widget.rider["id"]);
        //                     tokens.add(token!);
        //                     appareilUserRepository.sendNotif(
        //                         "Livraison en attente",
        //                         "Livraison près de chez vous",
        //                         idLivraison,
        //                         tokens);
        //                   }
        //                   if (widget.type == "foodee") {
        //                     String idcommande = await _commandeRepository
        //                         .insertCommande(widget.commande);
        //                     Restaurant r = context
        //                         .read<DeliveryData>()
        //                         .orderingRestaurant!;

        //                     idLivraison = await livraisonRepository
        //                         .addLivraisonWithCommande(
        //                             Livraison(
        //                                 dateenregistrement:
        //                                     widget.commande.dateenregistrement,
        //                                 description: context
        //                                     .read<DeliveryData>()
        //                                     .noteRidee
        //                                     .toString(),
        //                                 poids: 0,
        //                                 statut: "Created",
        //                                 prix: prix,
        //                                 iduser: widget.commande.iduser,
        //                                 idrider: widget.rider["id"],
        //                                 latitudeDepart:
        //                                     departLocation!.latitude.toString(),
        //                                 longitudeDepart: departLocation!
        //                                     .longitude
        //                                     .toString(),
        //                                 latitudeArrivee:
        //                                     multipoints[0].latitude.toString(),
        //                                 longitudeArrivee:
        //                                     multipoints[0].longitude.toString(),
        //                                 listnotepackee: null,
        //                                 idcommande: null,
        //                                 listpricepackee: null,
        //                                 multipoints: multipoints,
        //                                 multipointsAddress:
        //                                     multipointAddressList,
        //                                 namePlaceDepart: departaddress,
        //                                 namePlaceArrivee: "null"),
        //                             idcommande);
        //                     String? token =
        //                         await appareilUserRepository.getTokenById(r.id);
        //                     tokens.add(token!);
        //                     appareilUserRepository.sendNotif(
        //                         "Commande en attente",
        //                         "Nouveau commande chez vous",
        //                         idLivraison,
        //                         tokens);
        //                     appareilUserRepository.insertNotifResto(
        //                         idcommande,
        //                         "Commande en attente",
        //                         "Nouveau commande chez vous");
        //                   }

        //                   Future.delayed(Duration(seconds: 1), () {
        //                     setState(() {
        //                       isWaitASec = false;
        //                     });
        //                     Navigator.of(context).pushAndRemoveUntil(
        //                       MaterialPageRoute(
        //                           builder: (context) => MapliveredirectorScreen(
        //                                 type: widget.type,
        //                                 idLivraison: idLivraison,
        //                               )),
        //                       (Route<dynamic> route) => false,
        //                     );
        //                   });
        //                 },
        //           style: ButtonStyle(
        //             minimumSize: MaterialStateProperty.all(
        //               Size(double.infinity, 50),
        //             ),
        //           ),
        //           child: Text(
        //               isWaitASec ? 'En cours de traitement ...' : 'Commander'),
        //         ),
        //       ),
        //       //New button with transparent background
        //       Expanded(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             //Add your logic here
        //             Navigator.pop(context);
        //           },
        //           style: ButtonStyle(
        //             minimumSize: MaterialStateProperty.all(
        //               Size(double.infinity, 50),
        //             ),
        //             backgroundColor: MaterialStateProperty.all(Colors.red),
        //           ),
        //           child: Text('Annuler'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ]),
    );
  }
}
