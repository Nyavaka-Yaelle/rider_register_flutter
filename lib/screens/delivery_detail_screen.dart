

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:rider_register/repository/appareiluser_repository.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/map_detail.dart';

import '../widgets/sized_box_height.dart';

class DeliveryDetail extends StatefulWidget {
  String idLivraison;
  DeliveryDetail({required this.idLivraison});

  @override
  State<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  @override
  void initState() {
    super.initState();
  }

  LivraisonRepository livraisonRepository = new LivraisonRepository();
  AppareilUserRepository appareilUserRepository = new AppareilUserRepository();
  
  UserRepository userRepository = new UserRepository();
  Livraison? livraison;
  //get the delivery detail from idLivraison

  @override
  Widget build(BuildContext context) {
    Future<Livraison?> livraison =
        livraisonRepository.getLivraisonById(widget.idLivraison);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Récupération des données'),
        ),
        body: FutureBuilder<Livraison?>(
          future: livraison,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Text(snapshot.data!.latitudeArrivee.toString());
              // return a button
              print(
                  "latitude snap " + snapshot.data!.latitudeArrivee.toString());
              return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Lieu de départ: " +
                snapshot.data!.namePlaceDepart.toString()),
            const SizedBoxHeight(height: "sm"),
            Text("Lieu d'arrivée: " +
                snapshot.data!.namePlaceArrivee.toString()),
            const SizedBoxHeight(height: "sm"),
            Text("Description " +
                snapshot.data!.description.toString()),
            const SizedBoxHeight(height: "sm"),
            Text("Poids " + snapshot.data!.poids.toString()),

            ElevatedButton(onPressed: () async {
                //redirect to map
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapsRoutesExample(latitudeArrivee: double.parse(snapshot.data!.latitudeArrivee.toString()),
                       longitudeArrivee: double.parse(snapshot.data!.longitudeArrivee.toString()),
                        latitudeDepart: double.parse(snapshot.data!.latitudeDepart.toString()), 
                        longitudeDepart: double.parse(snapshot.data!.longitudeDepart.toString()),),
                    ),
                  );
              },
              child: const Text('Afficher sur la carte'),),
            ElevatedButton(
              onPressed: () async {
                // change the livraison idRider
                  User? user = userRepository.getCurrentUser();
                  livraisonRepository.updateLivraisonIdRider(
                      widget.idLivraison, user!.uid.toString());

                //send notification to the client
                  String clientId = snapshot.data!.iduser.toString();
                  appareilUserRepository.getTokenById(clientId).then((value) => 
                    {
                      appareilUserRepository.sendNotifToSingleUser(
                          "Votre livraison est en cours",
                          "Un livreur est en route pour vous livrer votre colis",
                          widget.idLivraison,
                          value.toString()
                          )
                    }
                  );
              },
              child: const Text('Accepter la livraison'),
            ),
          ],
        ),
      );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}