import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/models/commande.dart';

class CommandeRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // function insert commande to firestore
  Future<String> insertCommande(Commande commande) async {
    try {
      DocumentReference docRef = await _db.collection('commandes').add({
        'dateenregistrement': commande.dateenregistrement,
        'items': commande.items,
        'iduser': commande.iduser,
        'idrider': commande.idrider,
        'quantites': commande.quantites,
        'restaurant_id': commande.restaurantId,
        'prix': commande.prix,
        'notesitems': commande.notesitems,
      });
      print("Added Commande to Firestore with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding Commande to Firestore: $e");
      throw e;
    }
  }

  Future<Commande> getCommandeById(String id) async {
    DocumentSnapshot doc = await _db.collection('commandes').doc(id).get();
    return Commande.fromMap(doc.data() as Map<String, dynamic>);
  }
}
