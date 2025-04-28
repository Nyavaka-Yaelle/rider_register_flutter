import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/appareiluser_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/map_click_search.dart';
import 'package:location/location.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/services/api_service.dart' as api_service;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rider_register/widgets/sized_box_height.dart';

import '../models/livraison.dart';
import '../repository/position_repository.dart';

// Define a custom Form widget.
class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _DeliveryFormState extends State<DeliveryForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final PositionRepository positionRepository = new PositionRepository();
  final LivraisonRepository livraisonRepository = new LivraisonRepository();
  final UserRepository userRepository = new UserRepository();
  final AppareilUserRepository appareilUserRepository =
      new AppareilUserRepository();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Location location = new Location();
    User? user = userRepository.getCurrentUser();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    final _textControllerDepart = TextEditingController();
    final _textControllerDelivery = TextEditingController();
    final _textControllerDescription = TextEditingController();
    final _textControllerPoids = TextEditingController();
    final departLocation = context.watch<DeliveryData>().departLocation;
    final deliveryLocation = context.watch<DeliveryData>().deliveryLocation;
    final departAddress = context.watch<DeliveryData>().departAddress;
    final mulitpoints = context.watch<DeliveryData>().multipoint;
    final multipointAddress = context.watch<DeliveryData>().multipointAddress;
    List<String> multipointAddressList = [];
    //multipointsAddress is a list of dynamic that have an address attribute , we need to convert it to a list of string
    if (multipointAddress != null) {
      multipointAddress.forEach((element) {
        multipointAddressList.add(element['address']);
      });
    }
    final deliveryAddress = context.watch<DeliveryData>().deliveryAddress;
    if (departLocation != null) {
      //get city name
      if (departAddress != null) {
        _textControllerDepart.text = departAddress;
      } else {
        api_service.ApiService()
            .getFormattedAddresses(departLocation)
            .then((value) {
          _textControllerDepart.text = value;
        });
      }
    }
    if (deliveryLocation != null) {
      //get city name
      if (deliveryAddress != null) {
        _textControllerDelivery.text = deliveryAddress;
      } else {
        api_service.ApiService()
            .getFormattedAddresses(deliveryLocation)
            .then((value) {
          _textControllerDelivery.text = value;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Récupération des données'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _textControllerDepart,
                readOnly: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Map(isDepart: true),
                    ),
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Lieu de départ',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add_location),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Map(isDepart: true),
                        ),
                      );
                    },
                  ),
                )),
            TextField(
                controller: _textControllerDelivery,
                readOnly: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Map(isDepart: false),
                    ),
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Lieu de livraison',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () async {
                      // _serviceEnabled = await location.serviceEnabled();
                      // if (!_serviceEnabled) {
                      //   _serviceEnabled = await location.requestService();
                      //   if (!_serviceEnabled) {
                      //     return;
                      //   }
                      // }

                      // _permissionGranted = await location.hasPermission();
                      // if (_permissionGranted == PermissionStatus.denied) {
                      //   _permissionGranted = await location.requestPermission();
                      //   if (_permissionGranted != PermissionStatus.granted) {
                      //     return;
                      //   }
                      // }

                      // _locationData = await location.getLocation();
                      // _textControllerDelivery.text = _locationData.toString();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Map(isDepart: false),
                        ),
                      );
                    },
                  ),
                )),
            const SizedBoxHeight(height: "sm"),
            //TextFields for description and poids
            TextField(
              controller: _textControllerDescription,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBoxHeight(height: "sm"),
            //q: how to validate textfield to be number only?
            //a: https://stackoverflow.com/questions/50381234/how-to-validate-textfield-to-be-number-only-in-flutter
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _textControllerPoids,
              decoration: InputDecoration(
                labelText: 'Poids en kg',
              ),
            ),
            const SizedBoxHeight(height: "sm"),
            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_textControllerDepart.text.isNotEmpty &&
                    _textControllerDelivery.text.isNotEmpty &&
                    _textControllerDescription.text.isNotEmpty &&
                    _textControllerPoids.text.isNotEmpty) {
                  //insert Livraison to firestore
                  String idLivraison =
                      await livraisonRepository.addLivraison(Livraison(
                    dateenregistrement: Timestamp.now(),
                    description: _textControllerDescription.text,
                    //q: string to int flutter?
                    //a: int.parse(_textControllerPoids.text),
                    poids: int.parse(_textControllerPoids.text),
                    statut: "Created",
                    iduser: user!.uid,
                    latitudeDepart: departLocation!.latitude.toString(),
                    longitudeDepart: departLocation!.longitude.toString(),
                    latitudeArrivee: deliveryLocation!.latitude.toString(),
                    longitudeArrivee: deliveryLocation!.longitude.toString(),
                    multipoints: mulitpoints,
                    listnotepackee: null,
                    listpricepackee: null,
                    idcommande: null,
                    prix: null,
                    multipointsAddress: multipointAddressList,
                    namePlaceDepart: _textControllerDepart.text,
                    namePlaceArrivee: _textControllerDelivery.text,
                  ));

                  List<String> tokens = [];

                  //get token of rider near the delivery location and send notification
                  positionRepository
                      .getriderNearTheDeliveryLocationAndReturnTheTokenOfTheirPhone(
                          departLocation.latitude.toString(),
                          departLocation.longitude.toString(),
                          0)
                      .then((value) {
                    value.forEach((element) {
                      tokens.add(element.toString());
                    });
                    appareilUserRepository.sendNotif("Livraison en attente",
                        "Livraison près de chez vous", idLivraison, tokens);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez remplir tous les champs')),
                  );
                }
              },
              child: const Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}
