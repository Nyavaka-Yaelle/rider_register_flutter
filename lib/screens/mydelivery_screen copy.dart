import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:intl/intl.dart';
import 'package:rider_register/core/app_export.dart';
// Import other necessary packages and screens
import 'package:rider_register/screens/newmaplive.dart';
import 'package:rider_register/screens/rechooserider_screen.dart';
import 'package:rider_register/screens/map_live.dart';
import 'package:rider_register/screens/maplive_redirector_screen.dart';

class MyDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double hab = AppBar().preferredSize.height,
        hp = 4.h,
        hc = 92.h,
        lhs = MediaQuery.of(context).size.height - hab * 2 - (hc + hp);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.green5001,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 16.v, top: hp),
            height: hc,
            color: appTheme.green5001,
            alignment: Alignment.topLeft,
            child: Text(
              'Notification',
              style: TextStyle(
                color: scheme.onBackground,
                fontSize: 24.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: lhs,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('livraisons')
                  .where('iduser',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('statut', isNotEqualTo: "Arrived")
                  //Arrived
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
                  separatorBuilder: (BuildContext context, int index) {
                    // This is where you add the Divider between items.
                    return Divider(
                      height: 1, // Adjust the height of the Divider as needed
                      color: Colors
                          .grey, // You can change the color of the Divider here
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Timestamp dateenregistrementTimestamp =
                        doc['dateenregistrement'] as Timestamp;
                    DateTime dateenregistrementDateTime =
                        dateenregistrementTimestamp.toDate();
                    final formattedDateTimeString =
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(dateenregistrementDateTime);

                    String nameplacearrivee = doc['nameplacearrivee'] as String;
                    String nameplacedepart = doc['nameplacedepart'] as String;
                    double prix = doc['prix'] as double;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                : Colors
                                    .transparent, // Set the color based on status
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Image.asset('assets/logo/Ridee-1.png'),
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
                                              builder: (context) => Newmaplive(
                                                  idLivraison: doc.id),
                                            ),
                                          );
                                        else
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RechooseriderScreen(
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

                    // ListTile(
                    //   leading: Image.network("https://placehold.jp/75x75.png"),
                    //   title: Text(doc.id),
                    // trailing: ElevatedButton(
                    //   onPressed: () {
                    //     // navigate to map live
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => MapliveredirectorScreen(
                    //             idLivraison: doc.id, type: "ridee"),
                    //       ),
                    //     );
                    //   },
                    //   child: Text('Suivre'),
                    // ),
                    // );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

// canceled
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

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          child: Image.asset('assets/logo/Ridee-1.png'),
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

  // Extracted the StreamBuilder into a separate method for better readability
  Widget buildDeliveryStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livraisons')
          .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('statut', isNotEqualTo: "Arrived")
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

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          child: Image.asset('assets/logo/Ridee-1.png'),
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
}
