import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as reallocation;
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/services/api_service.dart';

import 'destination3loading_screen.dart';
import 'package:rider_register/theme/theme_helper.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rider_register/screens/destination3_screen.dart';


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
  //create a global context from a key
  // Créer une variable pour stocker la position actuelle du marqueur sur la carte
  LatLng _currentPosition = LatLng(-18.9102429923247, 47.53630939706369);
  String _currentAddress = '';
 
  @override
  _PlacedepartFoodeeScreenState createState() => _PlacedepartFoodeeScreenState();
}

class _PlacedepartFoodeeScreenState extends State<PlacedepartFoodeeScreen> {
  // Créer une classe qui hérite de State pour gérer l'état du widget
  Marker? marker;
  reallocation.LocationData? _departposition;
  Uint8List? markerIcon;
  BitmapDescriptor? bitmapDescriptor;
  List<Marker> _markers = [];
  int searchcount = 0;
  int searchlimit = 2; 
  int markerIdCounter = 0;
  List<dynamic> listaddress = [];
  ApiService apiService = ApiService();
  TextEditingController _textControllerDepartRidee = TextEditingController();
  int selectedIndex = -1;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  bool _isLoading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       markerIcon = await getBytesFromAsset('assets/logo/point Prendre.png', 64);
      bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);

      _getCurrentPosition();
    });
    super.initState();
    _initCurrentAddress();
    // Ajoutez un écouteur pour surveiller les changements dans le TextField
    _searchController.addListener(() {
      setState(() {}); /*Met à jour l'interface utilisateur*/
    });
  }

  // Fonction pour récupérer les suggestions depuis l'API Google Places
  IconData _getIconForType(List<dynamic> types) {
    if (types.contains('locality')) {
      return Icons.location_city; // Icône pour une ville
    } else if (types.contains('establishment')) {
      return Icons.store; // Icône pour un établissement
    } else if (types.contains('route')) {
      return Icons.alt_route; // Icône pour une route
    } else if (types.contains('point_of_interest')) {
      return Icons.place; // Icône pour un point d'intérêt
    } else if (types.contains('airport')) {
      return Icons.local_airport; // Icône pour un aéroport
    } else if (types.contains('transit_station')) {
      return Icons.train; // Icône pour une station de transit
    } else {
      return Icons.location_on; // Icône par défaut
    }
  }

  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.googleApikey}&components=country:mg";

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _suggestions = data['predictions'];
        });
      } else {
        print("Erreur API : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour sélectionner un lieu et récupérer ses détails
  Future<void> selectPlace(String placeId, String description) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${widget.googleApikey}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final geometry = data['result']['geometry']['location'];
        final lat = geometry['lat'];
        final lng = geometry['lng'];
        LatLng selectedPosition = LatLng(lat, lng);

        // Déplacez la caméra sur la position sélectionnée
        widget.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: selectedPosition, zoom: 17),
          ),
        );

        // Ajoutez un marqueur sur la position sélectionnée
        setState(() {
        
            _markers.add(
              Marker(
                markerId: MarkerId("Livraison"),
                position: selectedPosition,
                infoWindow: InfoWindow(title: "Adresse de livraison"),
                icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
              ),
            );

            // Mettez à jour les données pour le départ
            context
                .read<DeliveryData>()
                .setDepartLocationFoodee(selectedPosition);
            context.read<DeliveryData>().setDepartAddressFoodee(description);
          

          // Incrémentez le compteur de recherche
          _suggestions = [];
          _searchController.text = description;

        });

        print("Lieu sélectionné : $description ($lat, $lng)");
      } else {
        print("Erreur API : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }
  }

  void redirectToMyLocation() async {
    try {
      // Obtenir la position actuelle de l'utilisateur
      reallocation.LocationData currentLocation =
          await reallocation.Location().getLocation();

      // Vérifier si la position est valide
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng position = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        // Recentrer la caméra sur la position actuelle
        widget.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0, // Niveau de zoom
            ),
          ),
        );
        _initCurrentAddress();

        // Ajouter un marqueur à la position actuelle (facultatif)

        setState(() async {
          widget._currentPosition = position;

          widget._lastTap = position;
        
            context.read<DeliveryData>().setDepartLocationFoodee(position);
            String address =
                await apiService.getFormattedAddresses(widget._currentPosition);
            context.read<DeliveryData>().setDepartAddressFoodee(address);

            // context.read<DeliveryData>().setDepartAddressFoodee(null);
          
        });
      } else {
        print("Impossible d'obtenir la position actuelle.");
      }
    } catch (e) {
      print("Erreur lors de la récupération de la position : $e");
    }
  }

  @override
  void dispose() {
    // _searchController.removeListener(_onSearchChanged);
    // Supprimez l'écouteur lorsque le widget est détruit
    _searchController.dispose();
    super.dispose();
  }

  // Créer une méthode pour mettre à jour le contrôleur du widget GoogleMap lorsque celui-ci est créé
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      widget.mapController = controller;
    });
  }
  void _getCurrentPosition() async {
    try {
      _departposition = await reallocation.Location().getLocation();

      widget._currentPosition = LatLng(
          _departposition!.latitude ?? -18.9102429923247,
          _departposition!.longitude ?? 47.53630939706369);
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
    } catch (e) {
      // Handle the error
      rethrow;
    }
}
  //function that convert list of marker to list of latlng
  List<LatLng> _convertMarkerListToLatLng(List<Marker> markers) {
    List<LatLng> latLngs = [];
    for (var i = 0; i < markers.length; i++) {
      latLngs.add(markers[i].position);
    }
    return latLngs;
  }

  Future<void> _delayedPop(BuildContext context) async {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          transitionDuration: Duration.zero,
          barrierDismissible: false,
          barrierColor: Colors.black45,
          opaque: false,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 3));
    String verify = "";
    if (context.read<DeliveryData>().departLocationFoodee != null &&
        context.read<DeliveryData>().multipointAddress != null) {
      verify = "ok";
    }
    Navigator.of(context)
      ..pop()
      ..pop(verify);
  }



  Future<void> _initCurrentAddress() async {
    _suggestions = [];
    _searchController.clear();
    String address =
        await apiService.getFormattedAddresses(widget._currentPosition);
    setState(() {
      widget._currentAddress = address;
      if (context.read<DeliveryData>().departAddressFoodee == null)
        context.read<DeliveryData>().setDepartAddressFoodee(address);
      if (context.read<DeliveryData>().departLocationFoodee == null)
        context
            .read<DeliveryData>()
            .setDepartLocationFoodee(widget._currentPosition);
    });
  }

 
  bool isLoading = false;
  // Créer une méthode pour mettre à jour la position actuelle du marqueur lorsque l'utilisateur appuie sur la carte
  void _onMapTapped(LatLng position) async {
    setState(() {
      isLoading = true;
    });
      widget._currentPosition = position;
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
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final departLocationFoodee =
        context.read<DeliveryData>().departLocationFoodee;
    final departAddressFoodee = context.watch<DeliveryData>().departAddressFoodee;
    final deliveryAddressRidee =
        context.watch<DeliveryData>().deliveryAddressRidee;

    if (departLocationFoodee != null) {
      widget._currentPosition = departLocationFoodee!;
    }
    
    String apptitre = "Adresse d e livraison";

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(title: Text(apptitre.toString())),
        //fab check
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     WidgetsBinding.instance.addPostFrameCallback((_) {
        //       _delayedPop(context);
        //     });
        //   },
        //   child: Icon(Icons.check, color:scheme.onPrimary),
        //   backgroundColor: scheme.primary,
        // ),
        body: WillPopScope(
          onWillPop: () async {
            // Execute your function when the back button is pressed
            _delayedPop(context);
            // Return true to allow the back navigation or false to prevent it
            return false;
          },
          child: Center(
            child: Stack(
              children: [
                //map full screen
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                    markers:  {
                            // Ajouter un ensemble de marqueurs à afficher sur la carte
                            Marker(
                              // Créer un marqueur avec l'identifiant et la position actuelle du marqueur
                              markerId: MarkerId('current'),
                              icon: bitmapDescriptor ??
                                  BitmapDescriptor.defaultMarker,
                              position: widget._currentPosition,
                            ),
                          }
                        
                  ),
                ),

              //ajuster ma location
                Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.2,
                    right: 16,
                    child: Container(
                        height: 48, // Définir la hauteur du TextField
                        width: 48, // Définir la hauteur du TextField
                        decoration: BoxDecoration(
                          color:
                              scheme.surfaceContainerLowest, // Couleur de fond
                          borderRadius:
                              BorderRadius.circular(16.0), // Coins arrondis
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withOpacity(
                                  0.4), // Couleur de l'ombre avec opacité
                              spreadRadius: 0, // Rayon de diffusion
                              blurRadius: 2, // Rayon de flou
                              offset: Offset(
                                  0, 2), // Décalage horizontal et vertical
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.my_location_rounded,
                              color: scheme.primary),
                          onPressed: () => {redirectToMyLocation()},
                        ))),

                // simalution searchbar an md3 textfield
                if (_searchController.text.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      color: scheme.surfaceContainerHigh,
                      height: 32,
                    ),
                  ),
                // simalution searchbar an md3 textfield

                //simulation search view liste des adresses la
                //tokonyhoeto
                // Liste des suggestions
                if (_searchController.text.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 64,
                    child: Container(
                        color: scheme.surfaceContainerHigh,
                        // height: 200,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 96, // Hauteur minimale
                            maxHeight: ((_suggestions.length + 1) * 80.0).clamp(
                                96.0,
                                MediaQuery.of(context).size.height *
                                    0.5), // Ajuste dynamiquement la hauteur
                          ), // MediaQuery.of(context).size.height * 0.5, // Hauteur maximale (par exemple, 50% de l'écran)
                          child: _isLoading
                              ? Center(
                                  child: Container(
                                  margin: EdgeInsets.only(top: 18.0),
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(),
                                ))
                              : Flexible(
                                  child: ListView.builder(
                                  itemCount: _suggestions.isEmpty
                                      ? 1
                                      : _suggestions.length +
                                          1, // Inclure un élément si la liste est vide
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      // Premier élément : ListTile statique
                                      return ListTile(
                                        leading: Icon(
                                          Icons.location_on,
                                          color: scheme
                                              .onSurfaceVariant, // Couleur de l'icône
                                        ),
                                        title: Text(
                                          "Pointer sur la carte",
                                          style: TextStyle(
                                            color: scheme.onSurface,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        onTap: () {
                                          print(
                                              "Pointer sur la carte sélectionné");
                                          _suggestions = [];
                                          _searchController.clear();
                                          // Ajoutez ici la logique pour pointer sur la carte
                                        },
                                      );
                                    } else {
                                      // Suggestions dynamiques
                                      final suggestion =
                                          _suggestions[index - 1];
                                      return ListTile(
                                        leading: Icon(
                                          _getIconForType(suggestion['types']),
                                          color: scheme
                                              .onSurfaceVariant, // Couleur de l'icône
                                        ),
                                        title: Text(
                                          suggestion['structured_formatting']
                                              ['main_text'],
                                          style: TextStyle(
                                            color: scheme.onSurface,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          suggestion['structured_formatting']
                                              ['secondary_text'],
                                          style: TextStyle(
                                            color: scheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onTap: () => selectPlace(
                                          suggestion['place_id'],
                                          suggestion['description'],
                                        ),
                                      );
                                    }
                                  },
                                )),
                        )),
                  ),

                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 300), // Durée de l'animation
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(top: 32.0),
                        // padding: (_searchController.text.isNotEmpty)?
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                (_searchController.text.isNotEmpty) ? 0 : 16.0),
                        // EdgeInsets.only(top:32):
                        // EdgeInsets.symmetric( horizontal:16),
                        child: AnimatedContainer(
                            padding: EdgeInsets.symmetric(
                                horizontal: (_searchController.text.isNotEmpty)
                                    ? 16
                                    : 0),
                            duration: const Duration(
                                milliseconds: 300), // Durée de l'animation
                            curve: Curves.easeInOut,
                            height: 52, // Définir la hauteur du TextField
                            decoration: BoxDecoration(
                              color: scheme
                                  .surfaceContainerHigh, // Couleur de fond
                              borderRadius: BorderRadius.circular(
                                  (_searchController.text.isNotEmpty)
                                      ? 0
                                      : 100.0), // Coins arrondis
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.1), // Couleur de l'ombre avec opacité
                              //     spreadRadius: 0, // Rayon de diffusion
                              //     blurRadius: 2, // Rayon de flou
                              //     offset: Offset(0, 4), // Décalage horizontal et vertical
                              //   ),
                              // ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Back button
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context); // Navigate back
                                  },
                                ),
                                // Search input field
                                Expanded(
                                  child: TextField(
                                    enabled: searchcount < searchlimit,
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                    ),
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText:  departAddressFoodee != null
                                              ? "à " + departAddressFoodee
                                              : "Où livrons-nous votre plat ?",
                                      hintStyle: TextStyle(
                                        color: scheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                      ),

                                      border: InputBorder.none, // No border
                                    ),
                                    onChanged: (value) {
                                      // Handle search input changes
                                      print("Search input: $value");
                                      try {
                                        fetchSuggestions(value);
                                      } catch (e) {
                                        print("Error fetching suggestions: $e");
                                      }
                                      // print(_searchController.text);
                                    },
                                  ),
                                ),
                                // Clear button
                                if (_searchController.text.isNotEmpty)
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _suggestions = [];
                                        _searchController
                                            .clear(); // Clear the input
                                      });
                                    },
                                  ),
                              ],
                            )))),
                if (_searchController.text.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 80,
                    child: Container(
                      color: scheme.surfaceContainerHigh,
                      child: Divider(),
                    ),
                  ),

             
                // si setArrive fa arrive mbola null
                if (departAddressFoodee != null)
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withOpacity(
                                    0.4), // Couleur de l'ombre avec opacité
                                spreadRadius: 2, // Rayon de diffusion
                                blurRadius: 8, // Rayon de flou
                                offset: Offset(
                                    0, 4), // Décalage horizontal et vertical
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.my_location,
                                  color: scheme.primary,
                                ),
                                title: Text(
                                  departAddressFoodee ?? "Vous partez de ...",
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: GestureDetector(
                                    onTap: () => {
                                         
                                        },
                                    child: Icon(Icons.edit_outlined)),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                      onTap: () => {redirectToMyLocation()},
                                      child: Text(
                                        "Mon adresse initiale",
                                        style: TextStyle(
                                          color: scheme.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {
                                      print("Livrez plutôt ici !");
                                      
                                        if (context
                                                .read<DeliveryData>()
                                                .departLocationFoodee ==
                                            null) {
                                          print(
                                              "Erreur : departLocationFoodee est null");
                                          return;
                                        }

                                       
                                        final departLocationFoodee = context
                                            .read<DeliveryData>()
                                            .departLocationFoodee;
                                          Navigator.pop(context); // Navigate back
                                        
                                        
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                          40),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Text(
                                      "Livrez plutôt ici !",
                                      style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))),
                // Vos widgets ici
              ],
            ),
          ),
        ));
  }
}
