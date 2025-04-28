import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:location/location.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/repository/appareiluser_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:rider_register/screens/available_delivery_screen.dart';
import 'package:rider_register/screens/delivery_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/screens/mydelivery_screen.dart';

class PlaceholderScreen extends StatefulWidget {
  const PlaceholderScreen({Key? key}) : super(key: key);

  @override
  _PlaceholderScreenState createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  UserRepository userRepository = new UserRepository();
  UserFire.User? currentuser;
  AppareilUserRepository appareilUserRepository = new AppareilUserRepository();

  Future<void> positionWorker() async {
    bool _serviceEnabled;
    Location location = new Location();
    PermissionStatus _permissionGranted;
    // LocationData _locationData;
    // User? user = userRepository.getCurrentUser();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    User? user = userRepository.getCurrentUser();
    SessionManager().get("user").then((value) {
      UserFire.User user = UserFire.User.fromJson(value);

      setState(() {
        currentuser = user;
      });

      print("user loaded ${user.displayName}");
    });
    appareilUserRepository.addAppareilUser(user!.uid.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      positionWorker();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Placeholder '),
        title: Text('Emplacement'),
      ),
      drawer: NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  //const NavigationDrawer({Key? key}) : super(key: key);
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  UserFire.User? currentuser = null;
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    SessionManager().get("user").then((value) {
      UserFire.User user = UserFire.User.fromJson(value);

      setState(() {
        currentuser = user;
      });

      print("user ${user.displayName}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[50],
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                        'https://via.placeholder.com/60x60'),
                  ),
                  SizedBox(height: 10),
                  Text('${currentuser?.displayName}'),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Acceuil'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Livraison'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => (const DeliveryForm())));
              });
            },
          ),
          ListTile(
            title: Text('Déconnexion'),
            onTap: () {
              // Update the state of the app.
              setState(() {
                //Navigator.pop(context);
                userRepository.signOut().then((value) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AccueilScreen()),
                        (route) => false);
                  });
                });
              });

              // ...
              // Then close the drawer.

              //signout the user and delete session
              // userRepository.signOut().then((value) {

              // });
              //Navigator.pop(context);
            },
          ),
          //show ListTile only if user is a rider
          ListTile(
            title: Text('Mes Livraisons'),
            onTap: () {
              // Update the state of the app.
              setState(() {
                //Navigator.pop(context);

                // Future.delayed(const Duration(milliseconds: 500), () {
                //   Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => MyDeliveryScreen()));
                // });
              });

              // ...
              // Then close the drawer.

              //signout the user and delete session
              // userRepository.signOut().then((value) {

              // });
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
