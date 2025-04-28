import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rider_register/core/app_export.dart';
// Import other necessary packages and screens
import 'package:rider_register/screens/newmaplive.dart';
import 'package:rider_register/screens/rechooserider_screen.dart';
import 'package:rider_register/screens/map_live.dart';
import 'package:rider_register/screens/maplive_redirector_screen.dart';
import 'package:rider_register/repository/livraison_repository.dart';

class MyDeliveryScreen extends StatefulWidget {
  const MyDeliveryScreen({
    Key? key,
    required this.setIsShowBotNavBar,
    required this.changeTabIndex,
  }) : super(key: key);

  final Function(bool) setIsShowBotNavBar;
  final Function(int) changeTabIndex;

  @override
  _MyDeliveryScreenState createState() => _MyDeliveryScreenState();
}

class _MyDeliveryScreenState extends State<MyDeliveryScreen> {
  LivraisonRepository livraisonRepository = LivraisonRepository();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the bottom navigation bar
        widget.setIsShowBotNavBar(true);
        // Navigate to the Accueil tab (index 0)
        widget.changeTabIndex(0);
        return false; // Prevent default back navigation
      },
      child: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: scheme.surfaceContainer,
            foregroundColor: scheme.shadow,
            bottom: TabBar(
              tabs: [
                Tab(text: 'En Cours'), // Replace with your tab names
                Tab(text: 'En Attente'), // Replace with your tab names
                Tab(text: 'Terminé'),
              ],
            ),
            title: const Text('Mes livraisons'),
          ),
          body: TabBarView(
            children: [
              // First tab content
              buildDeliveryStreamBuilder(),
              buildDeliveryStreamBuilderCanceled(),
              buildDeliveryStreamBuilderArrived()
            ],
          ),
        ),
      ),
    );
  }

  // Extracted the StreamBuilder into a separate method for better readability
  Widget buildDeliveryStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livraisons')
          .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('statut', whereNotIn: ["Created", "canceled", "Arrived"])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Text(
              "Votre livraison est vide",
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1, color: Colors.grey),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Timestamp dateenregistrementTimestamp =
                doc['dateenregistrement'] as Timestamp;
            DateTime dateenregistrementDateTime =
                dateenregistrementTimestamp.toDate();
            final formattedDateTimeString = DateFormat('yyyy-MM-dd HH:mm')
                .format(dateenregistrementDateTime);

            String nameplacearrivee = doc['nameplacearrivee'] as String;
            String nameplacedepart = doc['nameplacedepart'] as String;
            double prix = doc['prix'] as double;
                  String type = "";
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data.containsKey('idcommande')) {
              type = "foodee";
            } else {
              type = "ridee";
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize: 10.0, // Adjust the font size to make the text smaller
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: doc["statut"] == "canceled"
                        ? Colors.yellow
                        : Colors.transparent, // Set the color based on status
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Image.asset(
                  type! == 'ridee' ? 'assets/logo/Ridee-1.png' : 'assets/images/foodee.png',
                ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                nameplacedepart,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Vers $nameplacearrivee',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('Ar $prix'),
                            ElevatedButton(
                              onPressed: () {
                                // navigate to map live
                                if (doc["statut"] != "canceled")
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Newmaplive(idLivraison: doc.id),
                                    ),
                                  );
                                else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RechooseriderScreen(
                                          idRider: doc["idrider"],
                                          idLivraison: doc.id),
                                    ),
                                  );
                              },
                              child: doc["statut"] == "canceled"
                                  ? Text('action')
                                  : Text('Suivre'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Canceled deliveries
  Widget buildDeliveryStreamBuilderCanceled() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livraisons')
          .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('statut', isEqualTo: "canceled")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Text(
              "Aucune livraison annulée",
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1, color: Colors.grey),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Timestamp dateenregistrementTimestamp =
                doc['dateenregistrement'] as Timestamp;
            DateTime dateenregistrementDateTime =
                dateenregistrementTimestamp.toDate();
            final formattedDateTimeString = DateFormat('yyyy-MM-dd HH:mm')
                .format(dateenregistrementDateTime);

            String nameplacearrivee = doc['nameplacearrivee'] as String;
            String nameplacedepart = doc['nameplacedepart'] as String;
            double prix = doc['prix'] as double;
      String type = "";
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data.containsKey('idcommande')) {
              type = "foodee";
            } else {
              type = "ridee";
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize: 10.0, // Adjust the font size to make the text smaller
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: doc["statut"] == "canceled"
                        ? Colors.yellow
                        : Colors.transparent, // Set the color based on status
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child:Image.asset(
                  type! == 'ridee' ? 'assets/logo/Ridee-1.png' : 'assets/images/foodee.png',
                ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                nameplacedepart,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Vers $nameplacearrivee',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('Ar $prix'),
                            ElevatedButton(
                              onPressed: () {
                                // navigate to map live
                                if (doc["statut"] != "canceled")
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Newmaplive(idLivraison: doc.id),
                                    ),
                                  );
                                else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RechooseriderScreen(
                                          idRider: doc["idrider"],
                                          idLivraison: doc.id),
                                    ),
                                  );
                              },
                              child: doc["statut"] == "canceled"
                                  ? Text('action')
                                  : Text('Suivre'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Arrived deliveries
  Widget buildDeliveryStreamBuilderArrived() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livraisons')
          .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('statut', isEqualTo: "Arrived")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Text(
              "Aucune livraison effectué",
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1, color: Colors.grey),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Timestamp dateenregistrementTimestamp =
                doc['dateenregistrement'] as Timestamp;
            DateTime dateenregistrementDateTime =
                dateenregistrementTimestamp.toDate();
            final formattedDateTimeString = DateFormat('yyyy-MM-dd HH:mm')
                .format(dateenregistrementDateTime);

            String nameplacearrivee = doc['nameplacearrivee'] as String;
            String nameplacedepart = doc['nameplacedepart'] as String;
            double prix = doc['prix'] as double;
              String type = "";
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data.containsKey('idcommande')) {
              type = "foodee";
            } else {
              type = "ridee";
            }
           print("type $type");
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize: 10.0, // Adjust the font size to make the text smaller
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: doc["statut"] == "canceled"
                        ? Colors.yellow
                        : Colors.transparent, // Set the color based on status
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child:Image.asset(
                  type! == 'ridee' ? 'assets/logo/Ridee-1.png' : 'assets/images/foodee.png',
                ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                nameplacedepart,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Vers $nameplacearrivee',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('Ar $prix'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}