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
import 'package:rider_register/services/api_service.dart';

import 'destination3loading_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final _formKey = GlobalKey<FormState>();

class PlacearriveScreen extends StatefulWidget {
  // Créer une classe qui hérite de StatefulWidget pour représenter l'écran avec état
  final bool isDepart;
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
    if(context.read<DeliveryData>().departLocationRidee != null &&
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
          listaddress.add(toadd);
          context.read<DeliveryData>().setDeliveryAddressRidee(value);
          context.read<DeliveryData>().setDeliveryLocationRidee(position);
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

            print("multipoint added " + list.toString());
            //context.read<DeliveryData>().setDeliveryAddressRidee(null);
          } else {
            context.read<DeliveryData>().setDepartLocationRidee(position);
            context.read<DeliveryData>().setDepartAddressRidee(null);
          }
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
              //context.read<DeliveryData>().setDeliveryAddressRidee(null);
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
        appBar: AppBar(title: Text(apptitre.toString())),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             WidgetsBinding.instance.addPostFrameCallback((_) {
      _delayedPop(context);
    });
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.teal,
        ),
        body: WillPopScope(
          onWillPop: () async {
            // Execute your function when the back button is pressed
            _delayedPop(context);
            // Return true to allow the back navigation or false to prevent it
            return false;
          },
          child: Center(
            child: Column(
              children: [
                InkWell(
                  // increment to prevent spamming
                  onTap: searchcount >= searchlimit ? null : () async {
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
                        searchcount++;
                        //increment search count
                        //print search count
                        print("Search Count " + searchcount.toString());
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
                          context.read<DeliveryData>().setDeliveryAddressRidee(
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
                          context.read<DeliveryData>().setDepartAddressRidee(
                              place.description.toString());
                        }

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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
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
                widget.isDepart == false
                    ? Expanded(
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 32,
                                    backgroundImage: CachedNetworkImageProvider(
                                        'https://picsum.photos/200'),
                                  ),
                                  title: Text(listaddress[index]["address"]),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        widget.type == "packee"
                                            ? IconButton(
                                                icon: Icon(Icons.note_add),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      String note = "";
                                                      String price = "";
                                                      final noteController =
                                                          TextEditingController(
                                                              text:
                                                                  listnotepackee[
                                                                          index]
                                                                      ["note"]);
                                                      final priceController =
                                                          TextEditingController(
                                                              text:
                                                                  listnotepackee[
                                                                          index]
                                                                      [
                                                                      "price"]);
                                                      return AlertDialog(
                                                        title: Text('Add Note'),
                                                        content: Form(
                                                          key: _formKey,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: ListBody(
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
                                                                      TextInputType
                                                                          .number,
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
                                                                Text('Annuler'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            // child: Text('Add'),
                                                            child:
                                                                Text('Ajouter'),
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                // Add the new note and price to the list
                                                                setState(() {
                                                                  if (note !=
                                                                      "") {
                                                                    listnotepackee[
                                                                            index]
                                                                        [
                                                                        "note"] = note;
                                                                  }

                                                                  if (price !=
                                                                      "") {
                                                                    listnotepackee[
                                                                            index]
                                                                        [
                                                                        "price"] = price;
                                                                  }
                                                                  context
                                                                      .read<
                                                                          DeliveryData>()
                                                                      .setNotePackee(
                                                                          listnotepackee);
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
                                                                    content: Text(
                                                                        "Veuillez remplir tous les champs requis"),
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
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _markers.removeWhere((marker) {
                                                return marker.markerId ==
                                                    MarkerId(listaddress[index]
                                                        ["id"]);
                                              });
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
                                              if (widget.type == "packee") {
                                                listnotepackee.removeAt(index);
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
                                                    .setMultipointAddress(null);
                                              } else {
                                                context
                                                    .read<DeliveryData>()
                                                    .setMultipointAddress(
                                                        listaddress);
                                                context
                                                    .read<DeliveryData>()
                                                    .setDeliveryAddressRidee(
                                                        listaddress[
                                                            listaddress.length -
                                                                1]["address"]);
                                                context
                                                    .read<DeliveryData>()
                                                    .setDeliveryLocationRidee(
                                                        context
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
                              ),
                            );
                          },
                        ),
                      )
                    : Padding(
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
                            style: ElevatedButton.styleFrom(
    minimumSize: Size(150, 60), // Set the width and height here
  ),
                        ),
                      ),

                // Vos widgets ici
              ],
            ),
          ),
        ));
  }
}
