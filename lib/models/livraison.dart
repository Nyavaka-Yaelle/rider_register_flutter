import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Livraison {
  String? iduser;
  String? idrider;
  Timestamp? dateenregistrement;
  Timestamp? datelivraison;
  String? statut;
  String? description;
  String? longitudeDepart;
  String? latitudeDepart;
  String? longitudeArrivee;
  String? latitudeArrivee;
  String? namePlaceDepart;
  String? namePlaceArrivee;
  List<LatLng>? multipoints;
  List<String>? multipointsAddress;
  List<String>? listnotepackee;
  List<double>? listpricepackee;
  int? poids;
  double? prix;
  String? idcommande;
  Livraison.empty();
  Livraison(
      {required this.iduser,
      this.idrider,
      required this.dateenregistrement,
      this.datelivraison,
      required this.statut,
      required this.description,
      required this.poids,
      required this.namePlaceDepart,
      required this.namePlaceArrivee,
      required this.longitudeDepart,
      required this.latitudeDepart,
      required this.longitudeArrivee,
      required this.latitudeArrivee,
      required this.multipoints,
      required this.multipointsAddress,
      required this.listnotepackee,
      required this.listpricepackee,
      required this.idcommande,
      required this.prix});

  Livraison.fromJson(Map<String, dynamic> json) {
    iduser = json['iduser'];
    idrider = json['idrider'];
    dateenregistrement = json['enregistrement'];
    datelivraison = json['livrer'];
    statut = json['statut'];
    description = json['description'];
    longitudeDepart = json['longitudeDepart'];
    latitudeDepart = json['latitudeDepart'];
    longitudeArrivee = json['longitudeArrivee'];
    latitudeArrivee = json['latitudeArrivee'];
    namePlaceDepart = json['namePlaceDepart'];
    namePlaceArrivee = json['namePlaceArrivee'];
    poids = json['poids'];
    multipoints = json['multipoints'];
    multipointsAddress = json['multipointsAddress'];
    listnotepackee = json['listnotepackee'];
    listpricepackee = json['listpricepackee'];
    idcommande = json['idcommande'];
    prix = json['prix'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['iduser'] = iduser;
    data['idrider'] = idrider;
    data['enregistrement'] = dateenregistrement;
    data['livrer'] = datelivraison;
    data['statut'] = statut;
    data['description'] = description;
    data['longitudeDepart'] = longitudeDepart;
    data['latitudeDepart'] = latitudeDepart;
    data['longitudeArrivee'] = longitudeArrivee;
    data['latitudeArrivee'] = latitudeArrivee;
    data['namePlaceDepart'] = namePlaceDepart;
    data['namePlaceArrivee'] = namePlaceArrivee;
    data['poids'] = poids;
    data['multipoints'] = multipoints;
    data['multipointsAddress'] = multipointsAddress;
    data['listnotepackee'] = listnotepackee;
    data['listpricepackee'] = listpricepackee;
    data['idcommande'] = idcommande;
    data['prix'] = prix;
    return data;
  }

  //create fromMap method
  Livraison.fromMap(Map<String, dynamic> mapData) {
    iduser = mapData['iduser'];
    idrider = mapData['idrider'];
    dateenregistrement = mapData['dateenregistrement'];
    datelivraison = mapData['datelivraison'];
    statut = mapData['statut'];
    description = mapData['description'];
    longitudeDepart = mapData['longitudedepart'];
    latitudeDepart = mapData['latitudedepart'];
    longitudeArrivee = mapData['longitudearrivee'];
    latitudeArrivee = mapData['latitudearrivee'];
    namePlaceDepart = mapData['nameplacedepart'];
    namePlaceArrivee = mapData['nameplacearrivee'];
    poids = mapData['poids'];
    prix = mapData['prix'];
    multipoints = (mapData['multipoints'] as List<dynamic>).map((geoPoint) {
      return LatLng(geoPoint.latitude, geoPoint.longitude);
    }).toList();
    multipointsAddress = (mapData['multipointsAddress']).cast<String>();
    listnotepackee = mapData['listnotepackee'] == null
        ? []
        : (mapData['listnotepackee']).cast<String>();
    listpricepackee = mapData['listpricepackee'] == null
        ? []
        : (mapData['listpricepackee']).cast<double>();
    idcommande = mapData['idcommande'] == null ? '' : mapData['idcommande'];
  }
}
