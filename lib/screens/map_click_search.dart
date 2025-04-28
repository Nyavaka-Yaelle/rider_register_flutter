import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';

class Map extends StatefulWidget {
  //if true, it is depart location, else it is delivery location
  final bool isDepart;
  Map({required this.isDepart});

  String googleApikey = "AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;

  String location = "Search Location";
  LatLng? _lastTap;
  Set<Marker> _markers = Set<Marker>();

  LatLng startLocation = LatLng(-18.9102429923247, 47.53630939706369);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Future<bool> _onWillPop() async {
    //check if isDepart is true and check if markers contains id "depart"
    if (widget.isDepart &&
        widget._markers.any((marker) => marker.markerId.value == "depart")) {
      Navigator.of(context).pop(true);
      return false;
    }
    //check if isDepart is false and check if markers contains id "livraison"
    else if (!widget.isDepart &&
        widget._markers.any((marker) => marker.markerId.value == "livraison")) {
      Navigator.of(context).pop(true);
      return false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Etês-vous sur de quitter la carte?'),
              content: Text("Vous n'avez pas encore indiqué de lieu."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Non'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Oui'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final departLocation = context.watch<DeliveryData>().departLocation;
    final deliveryLocation = context.watch<DeliveryData>().deliveryLocation;

    if (widget.isDepart) {
      if (departLocation != null) {
        widget.startLocation = departLocation;
      }
    } else {
      if (deliveryLocation != null) {
        widget.startLocation = deliveryLocation;
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Map"),
          ),
          body: Stack(children: [
            GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: widget.startLocation, //initial position
                zoom: 16.0, //initial zoom level
              ),
              mapType: MapType.normal, //map type
              onTap: (LatLng pos) {
                setState(() {
                  if (widget.isDepart) {
                    widget._lastTap = pos;
                    context.read<DeliveryData>().setDepartLocation(pos);
                    context.read<DeliveryData>().setDepartAddress(null);
                    //remove markers if id is "depart"
                    widget._markers.removeWhere(
                        (marker) => marker.markerId.value == "depart");
                    widget._markers.add(Marker(
                      markerId: MarkerId("depart"),
                      position: pos,
                      infoWindow: InfoWindow(
                        title: 'Lieu de départ',
                      ),
                    ));
                  } else {
                    widget._lastTap = pos;
                    context.read<DeliveryData>().setDeliveryAddress(null);
                    context.read<DeliveryData>().setDeliveryLocation(pos);
                    widget._markers.removeWhere(
                        (marker) => marker.markerId.value == "livraison");
                    widget._markers.add(Marker(
                      markerId: MarkerId("livraison"),
                      position: pos,
                      infoWindow: InfoWindow(
                        title: 'Lieu de livraison',
                      ),
                    ));
                  }
                });
              },
              markers: widget._markers,
              onMapCreated: (controller) {
                //method called when map is created
                setState(() {
                  if (deliveryLocation != null) {
                    widget._markers.add(Marker(
                      markerId: MarkerId("livraison"),
                      position: deliveryLocation,
                      infoWindow: InfoWindow(
                        title: 'Lieu de livraison',
                      ),
                    ));
                  }
                  if (departLocation != null) {
                    widget._markers.add(Marker(
                      markerId: MarkerId("depart"),
                      position: departLocation,
                      infoWindow: InfoWindow(
                        title: 'Lieu de départ',
                      ),
                    ));
                  }
                  widget.mapController = controller;
                });
              },
            ),

            //search autoconplete input
            Positioned(
                //search input bar
                top: 10,
                child: InkWell(
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
                          //add marker to map after search
                          if (widget.isDepart) {
                            widget._markers.add(Marker(
                              markerId: MarkerId("depart"),
                              position: newlatlang,
                              infoWindow: InfoWindow(
                                title: 'Lieu de départ',
                              ),
                            ));
                            //set depart location to selected place
                            context
                                .read<DeliveryData>()
                                .setDepartLocation(newlatlang);
                            //set depart location adress to selected place
                            context
                                .read<DeliveryData>()
                                .setDepartAddress(place.description.toString());
                          } else {
                            widget._markers.add(Marker(
                              markerId: MarkerId("livraison"),
                              position: newlatlang,
                              infoWindow: InfoWindow(
                                title: 'Lieu de livraison',
                              ),
                            ));
                            //set delivery location to selected place
                            context
                                .read<DeliveryData>()
                                .setDeliveryLocation(newlatlang);
                            //set delivery location adress to selected place
                            context.read<DeliveryData>().setDeliveryAddress(
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
                              title: Text(
                                widget.location,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Icon(Icons.search),
                              dense: true,
                            )),
                      ),
                    )))
          ])),
    );
  }
}
