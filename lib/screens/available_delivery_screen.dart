import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_register/screens/delivery_detail_screen.dart';

class AvailableDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livraison disponible'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // stream: FirebaseFirestore.instance
        //     .collection('livraisons')
        //     .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        //     .snapshots(),
        //stream that get all the delivery where idride is null
        stream: FirebaseFirestore.instance
            .collection('livraisons')
            .where('idrider', isEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: "https://placehold.jp/75x75.png",
                ),
                title: Text(doc['iduser']),
                trailing: ElevatedButton(
                  onPressed: () {
                    // do something with doc.id
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DeliveryDetail(idLivraison: doc.id),
                      ),
                    );
                  },
                  child: Text('Détail'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
