import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as reallocation;
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/screens/destination2_screen.dart';
import 'package:rider_register/services/api_service.dart';

import 'destination3loading_screen.dart';
import 'package:rider_register/theme/theme_helper.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rider_register/services/api_service.dart' as api_service;
import 'package:rider_register/screens/destination3_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final _formKey = GlobalKey<FormState>();

class PlacearriveScreen extends StatefulWidget {
  // Créer une classe qui hérite de StatefulWidget pour représenter l'écran avec état
  /*final*/ bool isDepart;
  final String type;
  PlacearriveScreen({required this.isDepart, required this.type});
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
  _PlacearriveScreenState createState() => _PlacearriveScreenState();
}

class _PlacearriveScreenState extends State<PlacearriveScreen> {
  // Créer une classe qui hérite de State pour gérer l'état du widget
  Marker? marker;
  reallocation.LocationData? _departposition;
  Uint8List? markerIcon;
  BitmapDescriptor? bitmapDescriptor;
  List<Marker> _markers = [];
  int searchcount = 0;
  int searchlimit = 2; // bloqué apres 2 recherches
  int markerIdCounter = 0;
  List<dynamic> listaddress = [];
  ApiService apiService = ApiService();
  TextEditingController _textControllerDepartRidee = TextEditingController();
  int selectedIndex = -1;
  List<dynamic> listnotepackee = [];
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  bool _isLoading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isDepart == false) {
        if (context.read<DeliveryData>().multipoint != null) {
          print("multipoint not null");
          _markers = _convertLatLngListToMarker(
              context.read<DeliveryData>().multipoint!);
        }
        if (context.read<DeliveryData>().multipointAddress != null) {
          listaddress = context.read<DeliveryData>().multipointAddress!;
        }
        if (context.read<DeliveryData>().notePackee != null) {
          listnotepackee = context.read<DeliveryData>().notePackee!;
        }
        markerIcon =
            await getBytesFromAsset('assets/logo/Point Arriver.png', 64);
        bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
      } else {
        markerIcon =
            await getBytesFromAsset('assets/logo/point Prendre.png', 64);
        bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
      }
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
          if (widget.isDepart == false) {
            print("markeeoooooo arrive");
            widget._lastTap = selectedPosition;
            _markers.clear(); // nampiana
            _markers.add(
              Marker(
                markerId: MarkerId((selectedPosition.toString())), //"Arrive"),
                position: selectedPosition,
                infoWindow: InfoWindow(title: "Lieu d'arrivée"),
                icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
              ),
            );
            // dynamic toadd = {
            // // "address": description,
            // "id": placeId,
            // "postion": selectedPosition,
            // 'highlighted': false
            // };
            // listaddress.add(toadd);
            // Mettez à jour les données pour l'arrivée
            dynamic toadd = {
              "address": description,
              "id": selectedPosition.toString(),
              "postion": selectedPosition,
              'highlighted': false
            };
            //  listaddress.add(toadd);
            if (listaddress.length == 0) {
              listaddress.add(toadd); // Ajoute si la liste est vide
            } else {
              print("tsy vide misy element");
              print(listaddress.length);
              listaddress[listaddress.length - 1] =
                  toadd; // Remplace le dernier élément
            }
            List<LatLng> list = _convertMarkerListToLatLng(_markers);
            context.read<DeliveryData>().setMultipoint(list);
            context.read<DeliveryData>().setMultipointAddress(listaddress);

            context
                .read<DeliveryData>()
                .setDeliveryLocationRidee(selectedPosition);
            context.read<DeliveryData>().setDeliveryAddressRidee(description);
          } else {
            _markers.add(
              Marker(
                markerId: MarkerId("Depart"),
                position: selectedPosition,
                infoWindow: InfoWindow(title: "Lieu de départ"),
                icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
              ),
            );

            // Mettez à jour les données pour le départ
            context
                .read<DeliveryData>()
                .setDepartLocationRidee(selectedPosition);
            context.read<DeliveryData>().setDepartAddressRidee(description);
          }

          // Incrémentez le compteur de recherche
          searchcount++;
          _suggestions = [];
          _searchController.text = description;

          print("Search Count: $searchcount");
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
          if (widget.isDepart == false) {
            _markers.add(
              Marker(
                markerId: MarkerId((position.toString())),
                infoWindow: InfoWindow(title: (markerIdCounter.toString())),
                position: position,
                onTap: () {
                  setState(() {
                    _markers.removeWhere((marker) {
                      print("AAAAAAAA " + marker.markerId.value);
                      print("BBBBBBB " + position.toString());

                      return marker.markerId == MarkerId(position.toString());
                    });
                    listaddress.removeWhere((address) {
                      return address["id"] == position.toString();
                    });
                  });
                  context
                      .read<DeliveryData>()
                      .setMultipoint(_convertMarkerListToLatLng(_markers));
                  context
                      .read<DeliveryData>()
                      .setMultipointAddress(listaddress);
                  print(_markers.length.toString());
                },
              ),
            );
            markerIdCounter++;

            print("List of Address " + listaddress.toString() + " ");
            List<LatLng> list = _convertMarkerListToLatLng(_markers);

            context.read<DeliveryData>().setMultipoint(list);
            context.read<DeliveryData>().setMultipointAddress(listaddress);

            print("multipoint added " + list.toString());
            //context.read<DeliveryData>().setDeliveryAddressRidee(null);
          } else {
            context.read<DeliveryData>().setDepartLocationRidee(position);
            String address =
                await apiService.getFormattedAddresses(widget._currentPosition);
            context.read<DeliveryData>().setDepartAddressRidee(address);

            // context.read<DeliveryData>().setDepartAddressRidee(null);
          }
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
          infoWindow: InfoWindow(title: (latLngs[i].toString())),
          onTap: () {
            setState(() {
              markers.removeWhere((marker) {
                print("AAAAAAAA " + marker.markerId.value);
                print("BBBBBBB " + latLngs[i].toString());

                return marker.markerId == MarkerId(latLngs[i].toString());
              });
              listaddress.removeWhere((address) {
                return address["id"] == latLngs[i].toString();
              });
            });
            context
                .read<DeliveryData>()
                .setMultipoint(_convertMarkerListToLatLng(markers));
            context.read<DeliveryData>().setMultipointAddress(listaddress);

            print(markers.length.toString());
          },
          icon: BitmapDescriptor.defaultMarker));
    }
    return markers;
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
    if (context.read<DeliveryData>().departLocationRidee != null &&
        context.read<DeliveryData>().multipointAddress != null) {
      verify = "ok";
    }
    Navigator.of(context)
      ..pop()
      ..pop(verify);
  }

  void _getCurrentPosition() async {
    if (widget.isDepart == true) {
      try {
        _departposition = await reallocation.Location().getLocation();

        widget._currentPosition = LatLng(
            _departposition!.latitude ?? -18.9102429923247,
            _departposition!.longitude ?? 47.53630939706369);
        widget.mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: widget._currentPosition, zoom: 17)));
        context
            .read<DeliveryData>()
            .setDepartLocationRidee(widget._currentPosition);
        await apiService
            .getFormattedAddresses(widget._currentPosition)
            .then((value) {
          setState(() {
            context.read<DeliveryData>().setDepartAddressRidee(value);
          });
        });
      } catch (e) {
        // Handle the error
        rethrow;
      }
    }
  }

  Future<void> _initCurrentAddress() async {
    _suggestions = [];
    _searchController.clear();
    String address =
        await apiService.getFormattedAddresses(widget._currentPosition);
    setState(() {
      widget._currentAddress = address;
      if (context.read<DeliveryData>().departAddressRidee == null)
        context.read<DeliveryData>().setDepartAddressRidee(address);
      if (context.read<DeliveryData>().departLocationRidee == null)
        context
            .read<DeliveryData>()
            .setDepartLocationRidee(widget._currentPosition);
    });
  }

  Future<bool?> _showDialog(String idposition) {
    String description = "";
    String price = "";
    bool isvalid = false;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Add Item'),
          title: Text('Ajouter un article'),
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(hintText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veuillez entrer la description du produit.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onChanged: (value) {
                    price = value;
                  },
                  // decoration: InputDecoration(hintText: 'Price'),
                  decoration: InputDecoration(hintText: 'Prix'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      // return 'Please enter the price of the product';
                      return "Veuillez entrer le prix du produit.";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              // child: Text('Cancel'),
              child: Text('Annuler'),
              onPressed: () {
                isvalid = false;
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              // child: Text('Add'),
              child: Text('Ajouter'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    listnotepackee.add({
                      'note': description,
                      'price': price,
                      'id': idposition
                    });
                  });
                  isvalid = true;
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar(content: Text('Please fill all the fields')),
                    SnackBar(content: Text("Veuillez remplir tous les champs")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool isLoading = false;
  // Créer une méthode pour mettre à jour la position actuelle du marqueur lorsque l'utilisateur appuie sur la carte
  void _onMapTapped(LatLng position) async {
    setState(() {
      isLoading = true;
    });
    // if (context != null &&
    //     context.owner != null &&
    //     context.owner!.debugBuilding) {}
    if (widget.isDepart == true) {
      widget._currentPosition = position;
      widget.mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: widget._currentPosition, zoom: 17)));
      context
          .read<DeliveryData>()
          .setDepartLocationRidee(widget._currentPosition);
      await apiService
          .getFormattedAddresses(widget._currentPosition)
          .then((value) {
        setState(() {
          context.read<DeliveryData>().setDepartAddressRidee(value);
        });
      });
    }
    if (widget.isDepart == false &&
        (widget.type == "ridee" || widget.type == "caree")) {
      await apiService.getFormattedAddresses(position).then((value) {
        setState(() {
          dynamic toadd = {
            "address": value,
            "id": position.toString(),
            "postion": position,
            'highlighted': false
          };
          //  listaddress.add(toadd);
          if (listaddress.length == 0) {
            listaddress.add(toadd); // Ajoute si la liste est vide
          } else {
            print("tsy vide misy element");
            print(listaddress.length);
            listaddress[listaddress.length - 1] =
                toadd; // Remplace le dernier élément
          }

          context.read<DeliveryData>().setDeliveryAddressRidee(value);
          context.read<DeliveryData>().setDeliveryLocationRidee(position);
        });
        setState(() async {
          widget._currentPosition = position;

          widget._lastTap = position;
          if (widget.isDepart == false) {
            // _markers.add(
            _markers = [
              Marker(
                markerId: MarkerId('arrivee'),
                // markerId: MarkerId((position.toString())),
                infoWindow: InfoWindow(title: (markerIdCounter.toString())),
                position: position,
                onTap: () {
                  setState(() {
                    _markers.removeWhere((marker) {
                      print("AAAAAAAA " + marker.markerId.value);
                      print("BBBBBBB " + position.toString());

                      return marker.markerId == MarkerId(position.toString());
                    });
                    listaddress.removeWhere((address) {
                      return address["id"] == position.toString();
                    });
                  });
                  context
                      .read<DeliveryData>()
                      .setMultipoint(_convertMarkerListToLatLng(_markers));
                  context
                      .read<DeliveryData>()
                      .setMultipointAddress(listaddress);
                  print(_markers.length.toString());
                },
              )
            ];
            // );
            markerIdCounter++;

            print("List of Address " + listaddress.toString() + " ");
            List<LatLng> list = _convertMarkerListToLatLng(_markers);

            context.read<DeliveryData>().setMultipoint(list);
            context.read<DeliveryData>().setMultipointAddress(listaddress);

            print("multipoint added " + list.toString());
            ////context.read<DeliveryData>().setDeliveryAddressRidee(null);
          } else {
            context.read<DeliveryData>().setDepartLocationRidee(position);
            String address =
                await apiService.getFormattedAddresses(widget._currentPosition);
            context.read<DeliveryData>().setDepartAddressRidee(address);

            // context.read<DeliveryData>().setDepartAddressRidee(null);
          }
          setState(() {
            isLoading = false;
          });
        });
      });
    }
    if (widget.isDepart == false && widget.type == "packee") {
      await apiService.getFormattedAddresses(position).then((value) async {
        bool? isvalide = await _showDialog(position.toString());
        if (isvalide == true) {
          setState(() {
            dynamic toadd = {
              "address": value,
              "id": position.toString(),
              "postion": position,
              'highlighted': false
            };
            //print isvalide is true or false
            print("isvalide " + isvalide.toString() + "");

            listaddress.add(toadd);
          });
          setState(() {
            widget._currentPosition = position;

            widget._lastTap = position;
            if (widget.isDepart == false) {
              _markers.add(
                Marker(
                  markerId: MarkerId((position.toString())),
                  infoWindow: InfoWindow(title: (markerIdCounter.toString())),
                  position: position,
                  onTap: () {
                    setState(() {
                      _markers.removeWhere((marker) {
                        print("AAAAAAAA " + marker.markerId.value);
                        print("BBBBBBB " + position.toString());

                        return marker.markerId == MarkerId(position.toString());
                      });
                      listaddress.removeWhere((address) {
                        return address["id"] == position.toString();
                      });
                    });
                    context
                        .read<DeliveryData>()
                        .setMultipoint(_convertMarkerListToLatLng(_markers));
                    context
                        .read<DeliveryData>()
                        .setMultipointAddress(listaddress);
                    print(_markers.length.toString());
                  },
                ),
              );
              markerIdCounter++;

              print("List of Address " + listaddress.toString() + " ");
              List<LatLng> list = _convertMarkerListToLatLng(_markers);

              context.read<DeliveryData>().setMultipoint(list);
              context.read<DeliveryData>().setMultipointAddress(listaddress);
              context.read<DeliveryData>().setNotePackee(listnotepackee);

              print("multipoint added " + list.toString());
              ////context.read<DeliveryData>().setDeliveryAddressRidee(null);
            } else {
              context.read<DeliveryData>().setDepartLocationRidee(position);
              context.read<DeliveryData>().setDepartAddressRidee(null);
            }
          });
        }
      });
    }

    // if (context != null &&
    //     context.owner != null &&
    //     context.owner!.debugBuilding) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deliveryLocationRidee =
        context.read<DeliveryData>().deliveryLocationRidee;
    final departLocationRidee =
        context.read<DeliveryData>().departLocationRidee;
    final departAddressRidee = context.watch<DeliveryData>().departAddressRidee;
    final deliveryAddressRidee =
        context.watch<DeliveryData>().deliveryAddressRidee;

    if (widget.isDepart == false) {
      if (deliveryLocationRidee != null) {
        widget._currentPosition = deliveryLocationRidee!;
      }
    } else {
      if (departLocationRidee != null) {
        widget._currentPosition = departLocationRidee!;
      }
    }
    String apptitre = "";
    if (widget.isDepart && widget.type != "packee")
      apptitre = "Point de départ";
    else if (!widget.isDepart && widget.type != "packee")
      apptitre = "Point d'arrivée";
    if (widget.isDepart && widget.type == "packee")
      apptitre = "Point de Livraison";
    else if (!widget.isDepart && widget.type == "packee")
      apptitre = "Point de recupération";

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
                    markers: widget.isDepart
                        ? {
                            // Ajouter un ensemble de marqueurs à afficher sur la carte
                            Marker(
                              // Créer un marqueur avec l'identifiant et la position actuelle du marqueur
                              markerId: MarkerId('current'),
                              icon: bitmapDescriptor ??
                                  BitmapDescriptor.defaultMarker,
                              position: widget._currentPosition,
                            ),
                          }
                        : Set<Marker>.of(_markers),
                  ),
                ),

                // liste des toerana no-clique-eny
                widget.isDepart == false
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listaddress.length + 1,
                            itemBuilder: (context, popo) {
                              if (popo == 0) {
                                // This is the text item before the houses
                                return Visibility(
                                  visible: isLoading,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(
                                            // You can customize the CircularProgressIndicator here
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.teal),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          Text("Recherche en cours ...")
                                        ]),
                                  ),
                                );
                              }
                              int index = popo - 1;

                              // if (
                              //   context.read<DeliveryData>().multipointAddress != null &&
                              //   context.read<DeliveryData>().multipointAddress!.isNotEmpty &&
                              //   popo == context.read<DeliveryData>().multipointAddress!.length - 1
                              //  ) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;

                                    listaddress[index]["highlighted"] = true;

                                    widget.mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: listaddress[index]["postion"],
                                        zoom: 19,
                                      ),
                                    ));
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: scheme.surfaceContainerLow,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: scheme.shadow.withOpacity(
                                            0.4), // Couleur de l'ombre avec opacité
                                        spreadRadius: 2, // Rayon de diffusion
                                        blurRadius: 8, // Rayon de flou
                                        offset: Offset(0,
                                            4), // Décalage horizontal et vertical
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 24),
                                  child: Column(children: [
                                    //dymanic miova

                                    // si setArrive fa arrive tsy null

                                    if (!widget.isDepart &&
                                        deliveryAddressRidee != null)
                                      ListTile(
                                        leading: Icon(
                                          Icons.location_on,
                                          color: scheme.error,
                                        ),
                                        // CircleAvatar(
                                        //   radius: 32,
                                        //   backgroundImage:
                                        //       CachedNetworkImageProvider(
                                        //           'https://picsum.photos/200'),
                                        // ),
                                        title: Text(
                                          listaddress[index]["address"],
                                          style: TextStyle(
                                            color: scheme.onSurface,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              widget.type == "packee"
                                                  ? IconButton(
                                                      icon:
                                                          Icon(Icons.note_add),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            String note = "";
                                                            String price = "";
                                                            final noteController =
                                                                TextEditingController(
                                                                    text: listnotepackee[
                                                                            index]
                                                                        [
                                                                        "note"]);
                                                            final priceController =
                                                                TextEditingController(
                                                                    text: listnotepackee[
                                                                            index]
                                                                        [
                                                                        "price"]);
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Add Note'),
                                                              content: Form(
                                                                key: _formKey,
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      TextFormField(
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Note',
                                                                        ),
                                                                        controller:
                                                                            noteController,
                                                                        onChanged:
                                                                            (value) {
                                                                          note =
                                                                              value;
                                                                        },
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            // return 'Please enter the note';
                                                                            return "Veuillez entrer la note.";
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                      TextFormField(
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              // 'Price',
                                                                              "Prix",
                                                                        ),
                                                                        controller:
                                                                            priceController,
                                                                        onChanged:
                                                                            (value) {
                                                                          price =
                                                                              value;
                                                                        },
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        inputFormatters: <
                                                                            TextInputFormatter>[
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly,
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            // return 'Please enter the price';
                                                                            return "Veuillez entrer le prix";
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      // Text('Cancel'),
                                                                      Text(
                                                                          'Annuler'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  // child: Text('Add'),
                                                                  child: Text(
                                                                      'Ajouter'),
                                                                  onPressed:
                                                                      () {
                                                                    if (_formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      // Add the new note and price to the list
                                                                      setState(
                                                                          () {
                                                                        if (note !=
                                                                            "") {
                                                                          listnotepackee[index]["note"] =
                                                                              note;
                                                                        }

                                                                        if (price !=
                                                                            "") {
                                                                          listnotepackee[index]["price"] =
                                                                              price;
                                                                        }
                                                                        context
                                                                            .read<DeliveryData>()
                                                                            .setNotePackee(listnotepackee);
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          // content: Text('Please fill all required fields'),
                                                                          content:
                                                                              Text("Veuillez remplir tous les champs requis"),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    )
                                                  : Container(),
                                              IconButton(
                                                //icon deleted taloha
                                                icon: Icon(Icons.edit_outlined,
                                                    color: scheme.outline),
                                                onPressed: () {
                                                  setState(() {
                                                    _markers
                                                        .removeWhere((marker) {
                                                      return marker.markerId ==
                                                          MarkerId(
                                                              listaddress[index]
                                                                  ["id"]);
                                                    });
                                                    _markers
                                                        .clear(); //mamafa an izy rehetra si tsy atao multipoint aloha
                                                    context
                                                        .read<DeliveryData>()
                                                        .setMultipoint(
                                                            _convertMarkerListToLatLng(
                                                                _markers));
                                                    print(context
                                                        .read<DeliveryData>()
                                                        .multipoint!
                                                        .length);
                                                    listaddress.removeAt(index);
                                                    if (widget.type ==
                                                        "packee") {
                                                      listnotepackee
                                                          .removeAt(index);
                                                      context
                                                          .read<DeliveryData>()
                                                          .setNotePackee(
                                                              listnotepackee);
                                                    }
                                                    if (listaddress.isEmpty) {
                                                      context
                                                          .read<DeliveryData>()
                                                          .setDeliveryAddressRidee(
                                                              null);
                                                      context
                                                          .read<DeliveryData>()
                                                          .setMultipointAddress(
                                                              null);
                                                    } else {
                                                      context
                                                          .read<DeliveryData>()
                                                          .setMultipointAddress(
                                                              listaddress);
                                                      context
                                                          .read<DeliveryData>()
                                                          .setDeliveryAddressRidee(
                                                              listaddress[listaddress
                                                                      .length -
                                                                  1]["address"]);
                                                      context
                                                          .read<DeliveryData>()
                                                          .setDeliveryLocationRidee(context
                                                              .read<
                                                                  DeliveryData>()
                                                              .multipoint![context
                                                                  .read<
                                                                      DeliveryData>()
                                                                  .multipoint!
                                                                  .length -
                                                              1]);
                                                    }
                                                  });
                                                },
                                              )
                                            ]),
                                        tileColor: selectedIndex == index
                                            ? Colors.grey
                                            : null,
                                      ),
                                    SizedBox(height: 16),
                                    if (!widget.isDepart)
                                      Center(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "Bouton Valider destination pressé");

                                          if (departAddressRidee == null ||
                                              departLocationRidee == null) {
                                            setState(() {
                                              widget.isDepart = true;
                                            });
                                          } else {
                                            if (context
                                                    .read<DeliveryData>()
                                                    .departLocationRidee ==
                                                null) {
                                              print(
                                                  "Erreur : departLocationRidee est null");
                                              return;
                                            }

                                            if (context
                                                        .read<DeliveryData>()
                                                        .multipoint ==
                                                    null ||
                                                context
                                                    .read<DeliveryData>()
                                                    .multipoint!
                                                    .isEmpty) {
                                              print(
                                                  "Erreur : multipoint est null ou vide");
                                              return;
                                            }
                                            final departLocationRidee = context
                                                .read<DeliveryData>()
                                                .departLocationRidee;
                                            final multipoint = context
                                                .read<DeliveryData>()
                                                .multipoint;

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Destination3Screen(
                                                  type: widget.type,
                                                  depart: departLocationRidee!,
                                                  arrivee: multipoint![
                                                      multipoint!.length - 1],
                                                ),
                                              ),
                                            );
                                            // WidgetsBinding.instance
                                            //     .addPostFrameCallback((_) {
                                            //   _delayedPop(context);
                                            // });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
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
                                          "Valider votre destination",
                                          style: TextStyle(
                                            color: scheme.onPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ))
                                  ]),
                                ),
                              );
                            },
                          ),
                        ))
                    :
                    //icon et note button la
                    SizedBox.shrink(),
                /*Positioned(
                      bottom:0,
                      // top:0,
                      left:0,
                      right:0,
                      child:Padding(
                        padding: EdgeInsets.all(10),
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
                                        InputDecoration(
                                            hintText:
                                                "Veuillez entrer la note"),
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
                                          setState(
                                            () {
                                              context
                                                  .read<DeliveryData>()
                                                  .setNoteRidee(
                                                      _textControllerDepartRidee
                                                          .text);
                                            },
                                          );
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
                            style: ElevatedButton.styleFrom( fixedSize: Size(150, 60), // Set the width and height here
                        ),
                        ),
                      )),*/
                //button mamoaka search an i google
                Positioned(
                  top: 64 + 18,
                  left: 16,
                  child: InkWell(
                    // increment to prevent spamming
                    onTap: searchcount >= searchlimit
                        ? null
                        : () async {
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: widget.googleApikey,
                                mode: Mode.overlay,
                                types: [],
                                strictbounds: false,
                                components: [
                                  Component(Component.country, 'mg')
                                ],
                                //google_map_webservice package
                                onError: (err) {
                                  print(err);
                                });

                            if (place != null) {
                              setState(() {
                                widget.location = place.description.toString();
                                searchcount++;
                                //increment search count
                                //print search count
                                print("Search Count " + searchcount.toString());
                                //set pinged location to search input
                              });

                              //form google_maps_webservice package
                              final plist = GoogleMapsPlaces(
                                apiKey: widget.googleApikey,
                                apiHeaders:
                                    await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              final geometry = detail.result.geometry!;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              var newlatlang = LatLng(lat, lang);

                              //move map camera to selected place with animation
                              widget.mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 17)));
                              setState(() {
                                //add marker to map after search
                                print(widget.isDepart.toString() + " depart");
                                if (widget.isDepart == false) {
                                  widget._markers.add(Marker(
                                    markerId: MarkerId("Arrive"),
                                    position: newlatlang,
                                    infoWindow: InfoWindow(
                                      title: "Lieu d'arrivée",
                                    ),
                                  ));
                                  //set depart location to selected place
                                  context
                                      .read<DeliveryData>()
                                      .setDeliveryLocationRidee(newlatlang);
                                  //set depart location adress to selected place
                                  context
                                      .read<DeliveryData>()
                                      .setDeliveryAddressRidee(
                                          place.description.toString());
                                } else {
                                  print("whe are here depart " +
                                      widget.isDepart.toString());

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
                                      .setDepartAddressRidee(
                                          place.description.toString());
                                }

                                //
                              });
                            }
                          },
                    child:
                        //search location link nefa textfield
                        SizedBox.shrink()
                    /*
                          Padding(
                        padding: EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: ListTile(
                              enabled: searchcount < searchlimit,
                              title: Text(
                                widget.location,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Icon(Icons.search),
                              dense: true,
                            ),
                          ),
                        ),
                      )
                      */
                    ,
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
                                      hintText: widget.isDepart
                                          ? widget.isDepart &&
                                                  departAddressRidee != null
                                              ? "de " + departAddressRidee
                                              : "D'où partez-vous ?"
                                          : !widget.isDepart &&
                                                  deliveryAddressRidee != null
                                              ? "à " + deliveryAddressRidee
                                              : "Où voulez-vous aller ? ",
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
                if (!widget.isDepart && deliveryAddressRidee == null)
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
                              if (!widget.isDepart)
                                ListTile(
                                  title: Text(
                                    'Vous êtes là',
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    departAddressRidee ?? "Votre position",
                                    style: TextStyle(
                                      color: scheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                      onTap: () => {
                                            setState(() {
                                              widget.isDepart = true;
                                            })
                                          },
                                      child: Icon(Icons.edit_outlined)),
                                ),
                            ],
                          ))),

                // si setArrive fa arrive mbola null
                if (widget.isDepart && departAddressRidee != null)
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
                                  departAddressRidee ?? "Vous partez de ...",
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: GestureDetector(
                                    onTap: () => {
                                          setState(() {
                                            widget.isDepart = true;
                                          })
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
                                        "Ma position initiale",
                                        style: TextStyle(
                                          color: scheme.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {
                                      print("Je pars de là");
                                      if (deliveryAddressRidee == null ||
                                          deliveryLocationRidee == null) {
                                        setState(() {
                                          widget.isDepart = false;
                                          _searchController.clear();
                                        });
                                      } else {
                                        if (context
                                                .read<DeliveryData>()
                                                .departLocationRidee ==
                                            null) {
                                          print(
                                              "Erreur : departLocationRidee est null");
                                          return;
                                        }

                                        if (context
                                                    .read<DeliveryData>()
                                                    .multipoint ==
                                                null ||
                                            context
                                                .read<DeliveryData>()
                                                .multipoint!
                                                .isEmpty) {
                                          print(
                                              "Erreur : multipoint est null ou vide");
                                          return;
                                        }
                                        final departLocationRidee = context
                                            .read<DeliveryData>()
                                            .departLocationRidee;
                                        final multipoint = context
                                            .read<DeliveryData>()
                                            .multipoint;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Destination3Screen(
                                              type: widget.type,
                                              depart: departLocationRidee!,
                                              arrivee: multipoint![
                                                  multipoint!.length - 1],
                                            ),
                                          ),
                                        );
                                        // WidgetsBinding.instance
                                        //     .addPostFrameCallback((_) {
                                        //   _delayedPop(context);
                                        // });
                                      }
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
                                      "Je pars de là",
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
