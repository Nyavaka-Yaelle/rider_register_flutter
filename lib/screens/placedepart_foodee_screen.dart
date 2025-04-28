import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as reallocation;
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/services/api_service.dart';

import 'destination3loading_screen.dart';

class PlacedepartFoodeeScreen extends StatefulWidget {
  // Créer une classe qui hérite de StatefulWidget pour représenter l'écran avec état
  PlacedepartFoodeeScreen({super.key});
  // Créer un contrôleur pour le widget GoogleMap
  String googleApikey = "AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;

  String location = "Search Location";
  LatLng? _lastTap;
  Set<Marker> _markers = Set<Marker>();

  // Créer une variable pour stocker la position actuelle du marqueur sur la carte
  LatLng _currentPosition = LatLng(-18.9102429923247, 47.53630939706369);

  @override
  _PlacedepartFoodeeScreenState createState() =>
      _PlacedepartFoodeeScreenState();
}

class _PlacedepartFoodeeScreenState extends State<PlacedepartFoodeeScreen> {
  // Créer une classe qui hérite de State pour gérer l'état du widget
  Marker? marker;
  reallocation.LocationData? _departposition;
  Uint8List? markerIcon;
  BitmapDescriptor? bitmapDescriptor;
  List<Marker> _markers = [];
  int markerIdCounter = 0;
  List<dynamic> listaddress = [];
  ApiService apiService = ApiService();
  TextEditingController _textControllerDepartRidee = TextEditingController();
  int selectedIndex = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      markerIcon = await getBytesFromAsset('assets/logo/point Prendre.png', 64);
      bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);

      _getCurrentPosition();
    });
    super.initState();
  }

  // Créer une méthode pour mettre à jour le contrôleur du widget GoogleMap lorsque celui-ci est créé
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      widget.mapController = controller;
    });
  }

  void _getCurrentPosition() async {
    _departposition = await reallocation.Location().getLocation();
    widget._currentPosition =
        new LatLng(_departposition!.latitude!, _departposition!.longitude!);
    widget.mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: widget._currentPosition, zoom: 17)));
    context
        .read<DeliveryData>()
        .setDepartLocationFoodee(widget._currentPosition);
    await apiService
        .getFormattedAddresses(widget._currentPosition)
        .then((value) {
      setState(() {
        context.read<DeliveryData>().setDepartAddressFoodee(value);
      });
    });
  }

  // Créer une méthode pour mettre à jour la position actuelle du marqueur lorsque l'utilisateur appuie sur la carte
  void _onMapTapped(LatLng position) async {
    await apiService.getFormattedAddresses(position).then((value) {
      setState(() {
        context.read<DeliveryData>().setDepartAddressFoodee(value);
      });
    });
    setState(() {
      widget._currentPosition = position;

      widget._lastTap = position;

      context.read<DeliveryData>().setDepartLocationRidee(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    final departLocationfoodee =
        context.watch<DeliveryData>().departLocationRidee;

    if (departLocationfoodee != null) {
      widget._currentPosition = departLocationfoodee;
    }

    String apptitre = "";
    apptitre = "Point de départ";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(apptitre.toString())),
      body: Column(
        children: [
          // Créer un widget GoogleMap qui occupe la moitié de l'écran
          InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: widget.googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'mg')],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    widget.location = place.description.toString();
                    //set pinged location to search input
                  });

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: widget.googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  widget.mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(target: newlatlang, zoom: 17)));
                  setState(() {
                    widget._markers.add(Marker(
                      markerId: MarkerId("Depart"),
                      position: newlatlang,
                      infoWindow: InfoWindow(
                        title: 'Lieu de départ',
                      ),
                      icon: bitmapDescriptor!,
                    ));
                    //set depart location to selected place
                    context
                        .read<DeliveryData>()
                        .setDepartLocationRidee(newlatlang);
                    //set depart location adress to selected place
                    context
                        .read<DeliveryData>()
                        .setDepartAddressRidee(place.description.toString());

                    //
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        title: Text(
                          widget.location,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.search),
                        dense: true,
                      )),
                ),
              )),
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated:
                  _onMapCreated, // Appeler la méthode _onMapCreated lorsque le widget GoogleMap est créé
              onTap:
                  _onMapTapped, // Appeler la méthode _onMapTapped lorsque l'utilisateur appuie sur la carte
              initialCameraPosition: CameraPosition(
                // Définir la position initiale de la caméra sur la carte
                target: widget
                    ._currentPosition, // Utiliser les coordonnées (0,0) comme point de départ
                zoom: 15.0, // Utiliser un niveau de zoom de 2.0
              ),
              markers: {
                // Ajouter un ensemble de marqueurs à afficher sur la carte
                Marker(
                  // Créer un marqueur avec l'identifiant et la position actuelle du marqueur
                  markerId: MarkerId('current'),
                  icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
                  position: widget._currentPosition,
                ),
              },
            ),
          ),

          // Créer une entrée qui affiche la latitude et la longitude de la position actuelle du marqueur
          SingleChildScrollView(
            child: SizedBox(
              height: listaddress.length > 1
                  ? MediaQuery.of(context).size.height / 4
                  : null,
              child: Column(children: [
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Open dialog with input that modifies text below

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String noteText = 'Initial text';
                              return AlertDialog(
                                title: Text('Note'),
                                content: TextField(
                                  controller: _textControllerDepartRidee,
                                  onChanged: (value) {
                                    noteText = value;
                                  },
                                  decoration:
                                      // InputDecoration(hintText: 'Enter note'),
                                      InputDecoration(hintText: "Entrez une note"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    // child: Text('Cancel'),
                                    child: Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        // Update text below with noteText
                                        setState(() {
                                          context
                                              .read<DeliveryData>()
                                              .setNoteRidee(
                                                  _textControllerDepartRidee
                                                      .text);
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                    // child: Text('Save'),
                                    child: Text('Sauver'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.note),
                        label: Text('Note'),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
