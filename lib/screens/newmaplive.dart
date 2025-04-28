import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/destination3_screen.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math';
import 'package:rider_register/repository/notif_repository.dart';
import '../main.dart';
import '../models/livraison.dart';
import '../models/user.dart';
import '../repository/livraison_repository.dart';
import '../repository/position_repository.dart';
import '../../repository/appareiluser_repository.dart';

import 'home_finally_page/Accueille.dart';
import 'mydelivery_screen.dart';
import 'myprofile_screen.dart';
import '../repository/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/app_export.dart';

//chat screen
class ChatScreen extends StatefulWidget {
  final String chatId;
  final String idRider;
  ChatScreen({required this.chatId, required this.idRider});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final chatrepository = ChatRepository();
  final userRepository = UserRepository();

  void sendMessage() {
    //get the current connected firebase user
    String? currentid = userRepository.getCurrentUser()?.uid;

    if (controller.text.isNotEmpty) {
      chatrepository.sendMessage(widget.chatId, widget.idRider ,currentid!, controller.text);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentid = userRepository.getCurrentUser()?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatrepository.getChatMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data!.docs[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: message['senderId'] == currentid
                              ? null
                              : Colors.green,
                          child: Text(message['senderId'] == currentid
                              ? 'User'
                              : 'Rider'),
                        ),
                        title: Text(message['text']),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Define the first screen as a stateful widget
class Newmaplive extends StatefulWidget {
  final String idLivraison;

  Newmaplive({required this.idLivraison});
  @override
  _NewmapliveState createState() => _NewmapliveState();
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
class _NewmapliveState extends State<Newmaplive> {
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Accueille()),
        );
      });
    }
    if (_currentIndex == 1) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
        // );
      });
    }
    if (_currentIndex == 2) {
      setState(() {
        _currentIndex = 0;
      });
    }
    if (_currentIndex == 3) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
        // );
      });
    }
  }

  // Define a future that waits for x seconds and returns true
  LatLng test1 = LatLng(-18.9102429923247, 47.53630939706369);
  LatLng test2 = LatLng(-18.915612, 47.521741);
  String googleApiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
  String totalDistance = 'No route';
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  Uint8List? markerIcon;
  Livraison? livraisonnotfuture;
  MapsRoutes route = MapsRoutes();
  Circle circle = Circle(circleId: CircleId('myCircle'));
  BitmapDescriptor? bitmapDescriptor;
  LivraisonRepository livraisonRepository = LivraisonRepository();
  PositionRepository positionRepository = PositionRepository();
  UserRepository userRepository = UserRepository();
  NotifRepository notifRepository = NotifRepository();
  AppareilUserRepository appareilUserRepository = AppareilUserRepository();
  String nomdepart = "";
  String nomarrive = "";
  String? tokenrider = "";
  Set<Polyline> _polylines = {};
  // Define a variable to store the index of the selected item
  int selectedIndex = -1;
  int _currentIndex = 0;
  int livraisonbadge = 0;

  dynamic rider = [];
  void onTabTapped(int index) {
    print("index $index");
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

  double calculateRotationAngle(double x, double y) {
    // Calculate the angle in degrees
    double angleRadians = atan2(y, x);
    double angleDegrees = angleRadians * (180.0 / pi);

    // Adjust the angle to be within [0, 360] degrees
    if (angleDegrees < 0) {
      angleDegrees += 360.0;
    }

    return angleDegrees;
  }

  @override
  void initState() {
    String idLivraison = widget.idLivraison; //widget.idLivraison;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
          notifRepository.makeNotifRead(idLivraison);

        markerIcon = await getBytesFromAsset('assets/logo/Moto.png', 64);
        print("mandeha pory");
        bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon!);
        Livraison? livraison =
            await livraisonRepository.getLivraisonById(idLivraison);
        tokenrider = await appareilUserRepository
            .getTokenById(livraison!.idrider.toString());
        print("idlivraison " + livraison!.idrider.toString() + "");
        Rider? user = await userRepository
            .getRiderByUserById(livraison.idrider.toString());
        dynamic ridertoshow = {
          'nombreLivraisonsArrived': user!.nombreLivraisonsArrived,
          'moyenneNote': user.moyenneNote,
          'vehicleLicencePlate': user.vehicleLicencePlate,
          'profilePicture': user.profilePicture,
          'title': user!.displayName,
          'description': 'You are the one and only',
          'number': '5',
          'anothertext': '2-4 personnes',
        };
        rider.add(ridertoshow);
        //add marker to map

        livraisonRepository.getLivraisonById(idLivraison).then((value) {
          livraisonnotfuture = value;
          print("idrider " + value!.idrider.toString());
          positionRepository
              .listenPosition(value!.idrider.toString())
              .listen((event) async {
            print("niova ra zao");
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(double.parse(event.latitude.toString()),
                        double.parse(event.longitude.toString())),
                    zoom: 15.0)));

            setState(() {
              if (value.namePlaceDepart != "null")
                nomdepart = value.namePlaceDepart!;
              else
                nomdepart = value.namePlaceArrivee!;

              nomarrive = value.multipointsAddress![0];

              _markers.removeWhere((m) => m.markerId.value == 'rider');
              _markers.add(Marker(
                markerId: MarkerId('rider'),
                anchor: const Offset(0.5, 0.5),
                position: LatLng(double.parse(event.latitude.toString()),
                    double.parse(event.longitude.toString())),
                infoWindow: InfoWindow(title: 'Position Livreur'),
                // rotation: calculateRotationAngle(
                //     event.rotation?[0] ?? 0.0, event.rotation?[1] ?? 0.0),
                icon: bitmapDescriptor!,
              ));
            });
          });
        });
      } catch (e, st) {
        print('Caught error: $e\n$st');
      }
    });

    super.initState();
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
    Future<Livraison?> livraison =
        livraisonRepository.getLivraisonById(widget.idLivraison);
    List<LatLng>? multipoint = [];
    List<LatLng> polylineCoordinates = [];
    String? currentid = userRepository.getCurrentUser()?.uid;
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Map Live'),
        title: const Text('Carte en direct'),
      ),
      body: Center(
        child: Column(children: [
          FutureBuilder<Livraison?>(
              future: livraison,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<LatLng> points = [];
                  multipoint = snapshot.data!.multipoints;
                  if (snapshot.data!.latitudeDepart != "null" &&
                      snapshot.data!.longitudeDepart != "null") {
                    points.add(LatLng(
                        double.parse(snapshot.data!.latitudeDepart.toString()),
                        double.parse(
                            snapshot.data!.longitudeDepart.toString())));
                  } else {
                    points.add(LatLng(
                        double.parse(snapshot.data!.latitudeArrivee.toString()),
                        double.parse(
                            snapshot.data!.longitudeArrivee.toString())));
                  }

                  points.addAll(multipoint!);
                  LatLng center = new LatLng(0, 0);
                  if (snapshot.data!.latitudeDepart == "null" &&
                      snapshot.data!.longitudeDepart == "null") {
                    center = LatLng(
                        ((double.parse(
                                    snapshot.data!.latitudeArrivee.toString()) +
                                double.parse(multipoint![multipoint!.length - 1]
                                    .latitude
                                    .toString())) /
                            2),
                        ((double.parse(snapshot.data!.longitudeArrivee
                                    .toString()) +
                                double.parse(multipoint![multipoint!.length - 1]
                                    .longitude
                                    .toString())) /
                            2));
                  } else {
                    LatLng center = LatLng(
                        ((double.parse(
                                    snapshot.data!.latitudeDepart.toString()) +
                                double.parse(snapshot.data!.latitudeArrivee
                                    .toString())) /
                            2),
                        ((double.parse(
                                    snapshot.data!.longitudeDepart.toString()) +
                                double.parse(snapshot.data!.longitudeArrivee
                                    .toString())) /
                            2));
                  }

                  return Expanded(
                    flex: 4,
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      polylines: _polylines,
                      markers: _markers,
                      // liteModeEnabled: true,
                      initialCameraPosition: CameraPosition(
                        zoom: 15.0,
                        target: center,
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        await route.drawRoute(points, 'Test routes',
                            Color.fromRGBO(105, 72, 155, 1), googleApiKey,
                            travelMode: TravelModes.driving);
                        //create a list of polylinecoordinates
                        //loop through the points and draw road using polylines and get route between each point
                        for (int i = 0; i < points.length - 1; i++) {
                          PolylinePoints polylinePoints = PolylinePoints();

                          PolylineResult result =
                              await polylinePoints.getRouteBetweenCoordinates(
                            googleApiKey,
                            PointLatLng(
                                points[i].latitude, points[i].longitude),
                            PointLatLng(points[i + 1].latitude,
                                points[i + 1].longitude),
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

                        Uint8List? markerIcon1 = await getBytesFromAsset(
                            'assets/logo/Point Arriver.png', 64);
                        BitmapDescriptor bitmapDescriptor1 =
                            BitmapDescriptor.fromBytes(markerIcon1!);
                        Uint8List? markerIcon2 = await getBytesFromAsset(
                            'assets/logo/point Prendre.png', 64);
                        BitmapDescriptor bitmapDescriptor2 =
                            BitmapDescriptor.fromBytes(markerIcon2!);
                        setState(() {
                          // Loop _markers list and change the icon if the marker id is different from rider
                          List<Marker> markers =
                              _convertLatLngListToMarker(multipoint!);
                          //loop to change the icon of the marker
                          for (var i = 0; i < markers.length; i++) {
                            markers[i] = markers[i].copyWith(
                              iconParam: bitmapDescriptor1,
                            );
                          }
                          _markers.addAll(markers);

                          _markers.add(
                            Marker(
                              markerId: MarkerId('depart'),
                              position: LatLng(
                                  double.parse(
                                      snapshot.data!.latitudeDepart.toString()),
                                  double.parse(snapshot.data!.longitudeDepart
                                      .toString())),
                              infoWindow: InfoWindow(title: 'Départ'),
                              icon: bitmapDescriptor2,
                            ),
                          );
                          totalDistance = snapshot.data!.statut.toString();
                        });
                      },
                    ),
                  );
                } else {
                  return Text("no data");
                }
              }),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: rider.length,
              itemBuilder: (context, index) {
                // Get the current item from the list
                final item = rider[index];
                return ListTile(
                  // Use leading to show an icon on the left
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
                      backgroundImage:
                          CachedNetworkImageProvider(item['profilePicture']),
                    ),
                  ),
                  title: Text(
                    item['vehicleLicencePlate'] as String,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.025,
                      ),
                      Text(
                        '${item['title'] as String}, vous prends',
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.025,
                      ),
                      Text(
                        '${item['moyenneNote'] as double} | ${item['nombreLivraisonsArrived']} course(s) ces 7 derniers jours.',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 0,
            child: ListTile(
              // Use leading to show an icon on the left
              leading: Container(
                // Use BoxDecoration to add a border around the image

                child: ClipRRect(
                  // Set circular radius as half of image size (64/2 = 32)
                  child: Image(
                    image: AssetImage(
                        'assets/images/logo.png'), // Load an asset image
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              // Use title to show a bold title
              title: Text(
                "Point de départ",
                style: TextStyle(fontSize: 20),
              ),
              // Use subtitle to show a short description below the title
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //     if (livraisonnotfuture!.namePlaceDepart != null)
                  Text(nomdepart,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  //context.read<DeliveryData>().orderingRestaurant!
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: ListTile(
              // Use leading to show an icon on the left
              leading: Container(
                child: ClipRRect(
                  // Set circular radius as half of image size (64/2 = 32)
                  child: Image(
                    image: AssetImage(
                        'assets/images/logo.png'), // Load an asset image
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              // Use title to show a bold title
              title: Text(
                "Point d'arrivée",
                style: TextStyle(fontSize: 20),
              ),
              // Use subtitle to show a short description below the title
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   if (livraisonnotfuture!.multipointsAddress != null)
                  Text(nomarrive,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Row(
                // Use a row to display the icon, text and button horizontally
                children: [
                  SizedBox(width: 10),
                  Image(
                    image: AssetImage(
                        "assets/images/identification-documents.png"),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Text("Monee" as String,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(width: 10),
                  SizedBox(width: 10),
                ]),
          ),
        ]),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ChatScreen(
                        chatId: livraisonnotfuture!.idrider.toString() + currentid!,
                        idRider: livraisonnotfuture!.idrider.toString()
                        ); // Replace this with your ChatScreen widget
                  },
                );
              },
              child: Icon(Icons.chat),
              backgroundColor: Colors.blue,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed logic here
              appareilUserRepository.updateRiderPosition(tokenrider!);
              print('Second FAB Pressed');
            },
            child: Icon(Icons.refresh),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: scheme.surfaceContainer,
        onDestinationSelected: _onItemTapped,
        selectedIndex: _currentIndex,
        destinations: <NavigationDestination>[
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: IconNotif(badge: livraisonbadge),
            selectedIcon:
                IconNotif(badge: livraisonbadge, icon: Icons.delivery_dining),
            label: 'Mes Livraisons',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
