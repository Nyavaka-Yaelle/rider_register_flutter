import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  List<String>? items;
  List<String>? notesitems;
  List<int>? quantites;
  List<double>? prix;
  String? iduser;
  String? idrider;
  String? restaurantId;
  Timestamp? dateenregistrement;

  Commande({
    this.items,
    this.quantites,
    this.prix,
    this.iduser,
    this.idrider,
    this.restaurantId,
    this.dateenregistrement,
    this.notesitems,
  });

  //Constructor with 0 parameters
  Commande.empty();

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      items: map['items'].cast<String>(),
      notesitems: map['notesitems'].cast<String>(),
      quantites: map['quantites'].cast<int>(),
      prix: map['prix'].cast<double>(),
      iduser: map['iduser'],
      idrider: map['idrider'],
      restaurantId: map['restaurant_id'],
      dateenregistrement: map['dateenregistrement'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'quantites': quantites,
      'prix': prix,
      'iduser': iduser,
      'notesitems': notesitems,
      'idrider': idrider,
      'restaurant_id': restaurantId,
      'dateenregistrement': dateenregistrement,
    };
  }

  //from json

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      items: json['items'],
      quantites: json['quantites'],
      prix: json['prix'],
      iduser: json['iduser'],
      idrider: json['idrider'],
      notesitems: json['notesitems'],
      restaurantId: json['restaurant_id'],
      dateenregistrement: json['dateenregistrement'],
    );
  }

  //to json

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'quantites': quantites,
      'prix': prix,
      'iduser': iduser,
      'idrider': idrider,
      'notesitems': notesitems,
      'restaurant_id': restaurantId,
      'dateenregistrement': dateenregistrement,
    };
  }
}
