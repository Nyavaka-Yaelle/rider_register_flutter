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
import 'package:intl/intl.dart';

class MyDeliveryScreen extends StatefulWidget {
  const MyDeliveryScreen({
    Key? key,
    required this.setIsShowBotNavBar,
    required this.changeTabIndex,
    required this.lastTabIndex,
  }) : super(key: key);

  final Function(bool) setIsShowBotNavBar;
  final Function(int) changeTabIndex;
  final int lastTabIndex; // Ajout du paramètre pour le dernier onglet

  @override
  _MyDeliveryScreenState createState() => _MyDeliveryScreenState();
}

class _MyDeliveryScreenState extends State<MyDeliveryScreen> {
  LivraisonRepository livraisonRepository = LivraisonRepository();
  String formatNumber(double n) {
    return NumberFormat("#,##0", "fr_FR").format(n);
  }

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

          appBar: PreferredSize(preferredSize: Size.fromHeight(132), // Ajustez la hauteur de l'AppBar
            child:AppBar(
            backgroundColor: scheme.surface,
            foregroundColor: scheme.shadow,
            elevation: 0,
              flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),

                IconButton(
                  icon: Icon(Icons.arrow_back), // Icône de flèche gauche
                  onPressed: () {
                    widget.changeTabIndex(widget.lastTabIndex); // Change l'onglet actif (par exemple, 0 pour "Accueil")
                    // Navigator.pop(context); // Action pour revenir en arrière
                  },
                ),
                // SizedBox(height: 4), // Espacement entre le titre et le sous-titre
                Container(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Mes livraisons', // Sous-titre ou description
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: scheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    decoration: TextDecoration.none,
                  ),
                )),
              ],
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'En attente'), // Remplacez par vos noms d'onglets
                Tab(text: 'En cours'),
                Tab(text: 'Terminé'),
              ],
            ),
          )),
          backgroundColor: scheme.surfaceContainerLowest,
          body: TabBarView(
            children: [
              // First tab content
              buildDeliveryStreamBuilderCanceled(),
              buildDeliveryStreamBuilder(),
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
          .where('statut',
              whereNotIn: ["Created", "canceled", "Arrived"]).snapshots(),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize:
                          10.0, // Adjust the font size to make the text smaller
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
                            type! == 'ridee'
                                ? 'assets/logo/Ridee-1.png'
                                : 'assets/images/foodee.png',
                          ),
                        ),
                       SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(formatNumber(prix)+' Ar'),
                           (doc["statut"] != "canceled") ?ElevatedButton(
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
                              child: 
                              //doc["statut"] == "canceled"
                              //     ? Text('action')
                              //     : 
                                  Text('Suivre'),
                            ): SizedBox.shrink(),
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
              "Aucune livraison en attente", //annulée",
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
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize:
                          10.0, // Adjust the font size to make the text smaller
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // color: doc["statut"] == "canceled"  ? Colors.yellow   : Colors.transparent, // Set the color based on status
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Image.asset(
                            type! == 'ridee'
                                ? 'assets/logo/Ridee-1.png'
                                : 'assets/images/foodee.png',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(formatNumber(prix)+' Ar'),
                            /*ElevatedButton(
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
                            ),*/
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
              "Aucune livraison effectuée",
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
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    formattedDateTimeString,
                    style: TextStyle(
                      fontSize:
                          10.0, // Adjust the font size to make the text smaller
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // color: doc["statut"] == "canceled"
                    //     ? Colors.yellow
                    //     : Colors.transparent, // Set the color based on status
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Image.asset(
                            type! == 'ridee'
                                ? 'assets/logo/Ridee-1.png'
                                : 'assets/images/foodee.png',
                          ),
                        ),
                         SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(formatNumber(prix)+' Ar'),
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
