import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/models/livraison.dart';

class LivraisonRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // function insert livraison to firestore
  Future<String> addLivraison(Livraison livraison) async {
    try {
      //convert list of LatLng to list of GeoPoint
      List<GeoPoint> geoPoints = [];
      for (var point in livraison.multipoints!) {
        geoPoints.add(GeoPoint(point.latitude, point.longitude));
      }
      DocumentReference docRef = await _db.collection('livraisons').add({
        'dateenregistrement': livraison.dateenregistrement,
        'datelivraison': livraison.datelivraison,
        'description': livraison.description,
        'poids': livraison.poids,
        'statut': livraison.statut,
        'idrider': livraison.idrider,
        'iduser': livraison.iduser,
        'latitudedepart': livraison.latitudeDepart,
        'longitudedepart': livraison.longitudeDepart,
        'latitudearrivee': livraison.latitudeArrivee,
        'longitudearrivee': livraison.longitudeArrivee,
        'nameplacedepart': livraison.namePlaceDepart,
        'nameplacearrivee': livraison.namePlaceArrivee,
        'multipoints': geoPoints,
        'prix': livraison.prix,
        'multipointsAddress': livraison.multipointsAddress,
      });
      print("Added Livraison to Firestore with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding Livraison to Firestore: $e");
      throw e;
    }
  }
//Function check type , if idcommande doesnt extist then return type foodee else its ridee
  String checkType(DocumentSnapshot doc) {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('idcommande')) {
        return "foodee";
      } else {
        return "ridee";
      }
    } else {
      print("Livraison does not exist");
      return "foodee";
    }
  }
  


    
  Future<String> addLivraisonPackee(Livraison livraison) async {
    try {
      //convert list of LatLng to list of GeoPoint
      List<GeoPoint> geoPoints = [];
      for (var point in livraison.multipoints!) {
        geoPoints.add(GeoPoint(point.latitude, point.longitude));
      }
      DocumentReference docRef = await _db.collection('livraisons').add({
        'dateenregistrement': livraison.dateenregistrement,
        'datelivraison': livraison.datelivraison,
        'description': livraison.description,
        'poids': livraison.poids,
        'statut': livraison.statut,
        'idrider': livraison.idrider,
        'iduser': livraison.iduser,
        'latitudedepart': livraison.latitudeDepart,
        'longitudedepart': livraison.longitudeDepart,
        'latitudearrivee': livraison.latitudeArrivee,
        'longitudearrivee': livraison.longitudeArrivee,
        'nameplacedepart': livraison.namePlaceDepart,
        'nameplacearrivee': livraison.namePlaceArrivee,
        'multipoints': geoPoints,
        'prix': livraison.prix,
        'multipointsAddress': livraison.multipointsAddress,
        'listpricepackee': livraison.listpricepackee,
        'listnotepackee': livraison.listnotepackee,
      });
      print("Added Livraison to Firestore with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding Livraison to Firestore: $e");
      throw e;
    }
  }

// function insert livraison to firestore
  Future<String> addLivraisonWithCommande(
      Livraison livraison, String idCommande) async {
    try {
      //convert list of LatLng to list of GeoPoint
      List<GeoPoint> geoPoints = [];
      for (var point in livraison.multipoints!) {
        geoPoints.add(GeoPoint(point.latitude, point.longitude));
      }
      DocumentReference docRef = await _db.collection('livraisons').add({
        'dateenregistrement': livraison.dateenregistrement,
        'datelivraison': livraison.datelivraison,
        'description': livraison.description,
        'poids': livraison.poids,
        'statut': livraison.statut,
        'idrider': livraison.idrider,
        'prix': livraison.prix,
        'iduser': livraison.iduser,
        'latitudedepart': livraison.latitudeDepart,
        'longitudedepart': livraison.longitudeDepart,
        'latitudearrivee': livraison.latitudeArrivee,
        'longitudearrivee': livraison.longitudeArrivee,
        'nameplacedepart': livraison.namePlaceDepart,
        'nameplacearrivee': livraison.namePlaceArrivee,
        'multipoints': geoPoints,
        'idcommande': idCommande,
        'multipointsAddress': livraison.multipointsAddress,
      });
      print("Added Livraison to Firestore with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding Livraison to Firestore: $e");
      throw e;
    }
  }

//get Livraison by id
  Future<Livraison?> getLivraisonById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('livraisons').doc(id).get();
      if (doc.exists) {
        return Livraison.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print("Livraison with ID $id does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting Livraison: $e");
      throw e;
    }
  }

//get all lirasion that doest not have a idrider and statut = created
  Future<List<Livraison>> getLivraisonsWithNoRider() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('livraisons')
          .where('idrider', isEqualTo: null)
          .where('statut', isEqualTo: 'Created')
          .get();
      List<Livraison> livraisons = [];
      querySnapshot.docs.forEach((doc) {
        livraisons.add(Livraison.fromMap(doc.data() as Map<String, dynamic>));
      });
      return livraisons;
    } catch (e) {
      print("Error getting Livraisons: $e");
      throw e;
    }
  }

//get all lirasion that doest not have a idrider and statut = created
  Future<int> getLivraisonsCanceledByIdUserCount(String id) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('livraisons')
          .where('iduser', isEqualTo: id)
          .where('statut', isEqualTo: 'canceled')
          .get();
      List<Livraison> livraisons = [];
      querySnapshot.docs.forEach((doc) {
        livraisons.add(Livraison.fromMap(doc.data() as Map<String, dynamic>));
      });
      return livraisons.length;
    } catch (e) {
      print("Error getting Livraisons: $e");
      throw e;
    }
  }

// get last livrasion that doest not have a idrider and statut = created ; but also return the id of the livraison
  Future<Map<String, dynamic>> getLastLivraisonWithNoRider() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('livraisons')
          .where('statut', isEqualTo: 'canceled')
          .orderBy('dateenregistrement', descending: true)
          .limit(1)
          .get();
      List<Livraison> livraisons = [];
      querySnapshot.docs.forEach((doc) {
        livraisons.add(Livraison.fromMap(doc.data() as Map<String, dynamic>));
      });
      if (livraisons.isEmpty) {
        Livraison l = Livraison.empty();
        return {'livraison': l, 'id': ""};
      } else
        return {'livraison': livraisons[0], 'id': querySnapshot.docs[0].id};
    } catch (e) {
      print("Error getting Livraisons: $e");
      throw e;
    }
  }

//update the livraison idrider field in firestore
  Future<void> updateLivraisonIdRider(String id, String idrider) async {
    try {
      //check if the idrider in the livraison is null
      //if null then update the idrider
      //else throw an exception
      print("update clicked $id dsdsds $idrider ");
      DocumentSnapshot doc = await _db.collection('livraisons').doc(id).get();
      if (doc.exists) {
        if (doc.get('idrider') != null) {
          throw Exception("Livraison with ID $id already has a rider");
        } else {
          await _db
              .collection('livraisons')
              .doc(id)
              .update({'idrider': idrider});
          print("Livraison with ID $id updated");
        }
      }
    } catch (e) {
      print("Error updating Livraison: $e");
      throw e;
    }
  }

  //
  Future<void> removeFieldFromDocument(
      String documentId, String fieldName) async {
    FirebaseFirestore.instance
        .collection('livraisons')
        .doc(documentId)
        .update({fieldName: FieldValue.delete()})
        .then((_) => print('Field $fieldName removed successfully'))
        .catchError((error) => print('Failed to remove field: $error'));
  }

//update the livraison statut field in firestore
  Future<void> updateLivraisonStatut(String id, String statut) async {
    try {
      await _db.collection('livraisons').doc(id).update({'statut': statut});
      print("Livraison with ID $id updated");
    } catch (e) {
      print("Error updating Livraison: $e");
      throw e;
    }
  }

//update the livraison statut field in firestore
  Future<void> updateLivraisonRider(String id, String idrider) async {
    try {
      await _db.collection('livraisons').doc(id).update({'idrider': idrider});
      print("Livraison with ID $id updated");
    } catch (e) {
      print("Error updating Livraison: $e");
      throw e;
    }
  }

  //update the delivery date in firestore
  Future<void> updateLivraisonDateLivraison(String id) async {
    DateTime now = DateTime.now();
    Timestamp datelivraison = Timestamp.fromDate(now);
    try {
      await _db
          .collection('livraisons')
          .doc(id)
          .update({'datelivraison': datelivraison});
      print("Livraison with ID $id updated");
    } catch (e) {
      print("Error updating Livraison: $e");
      throw e;
    }
  }


  //check if the rider has a delivery in progress that return the delivery
  Future<String?> checkIfRiderHasDeliveryInProgress(String idrider) async {
    List<String> statuts = ['canceled', 'Arrived', 'null'];
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('livraisons')
          .where('idrider', isEqualTo: idrider)
          .where('statut', whereNotIn: statuts)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        //print("not empty");
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      // print("Error checking if rider has delivery in progress: $e");
      rethrow;
    }
  }


Future<ConfigPrixLivraison?> getConfigPrixLivraison(String type) async {
    if(type == "foodee"){
      //get the km initial course from firestore
      DocumentSnapshot doc = await _db.collection('config').doc('prixFoodeeKm').get();
      if (doc.exists) {
        double kmInitialCourse = doc.get('kmInitialCourse');
        double prixInitialCourse = doc.get('prixInitialCourse');
        double prixParKm = doc.get('prixParKm');

        return ConfigPrixLivraison(kmInitialCourse, prixInitialCourse, prixParKm);
      } 
    }
    if(type == "ridee"){
      DocumentSnapshot doc = await _db.collection('config').doc('prixRideeKm').get();
      if (doc.exists) {
        double kmInitialCourse = doc.get('kmInitialCourse');
        double prixInitialCourse = doc.get('prixInitialCourse');
        double prixParKm = doc.get('prixParKm');

        return ConfigPrixLivraison(kmInitialCourse, prixInitialCourse, prixParKm);
      } 
    }
    return null;
}

  //price calculator
Future<double> calculerPrixLivraison(String type, double distance) async {
    double prixLivraison = 0;
    if(type == "foodee"){
      ConfigPrixLivraison? config = await getConfigPrixLivraison("foodee");
      if(distance <= config!.kmInitialCourse!) {
        prixLivraison = config.prixInitialCourse!;
      } else {
        prixLivraison = config.prixInitialCourse! + (distance - config.kmInitialCourse!) * config.prixParKm!;
      }
    }
    if(type == "ridee"){
      ConfigPrixLivraison? config = await getConfigPrixLivraison("ridee");
      if(distance <= config!.kmInitialCourse!) {
        prixLivraison = config.prixInitialCourse!;
      } else {
        prixLivraison = config.prixInitialCourse! + (distance - config.kmInitialCourse!) * config.prixParKm!;
      }
    }
    return prixLivraison;
  }
}


Future<double> calculerPrixCommissionApp(String typePayment, double prixTotalLivraison ) async{
  double prixCommission = 0;
  if(typePayment == "cash"){
    //commission is 40% of the delivery price
    prixCommission = prixTotalLivraison * 0.4;
  }
  if(typePayment == "jeton"){
    //commission is 20% of the delivery price
    prixCommission = prixTotalLivraison * 0.2;
  }
  return prixCommission;
}

class ConfigPrixLivraison{
  double? kmInitialCourse;
  double? prixInitialCourse;
  double? prixParKm;

  ConfigPrixLivraison(this.kmInitialCourse, this.prixInitialCourse, this.prixParKm);
}
