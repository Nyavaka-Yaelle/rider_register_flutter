import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/models/livraison.dart';

import '../models/note.dart';

class NoteRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // function insert livraison to firestore
  Future<String> addNote(Note note) async {
    try {
      DocumentReference docRef = await _db.collection('notes').add({
        'idrider': note.idrider,
        'idlivraison': note.idlivraison,
        'note': note.note,
        'commentaire': note.commentaire,
        'ameliorer': note.ameliorer,
        'pourboire': note.pourboire,
      });
      print("Added Note to Firestore with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding Note to Firestore: $e");
      throw e;
    }
  }
}
