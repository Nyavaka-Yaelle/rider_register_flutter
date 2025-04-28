import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/models/livraison.dart';

import '../models/note.dart';
import '../models/pub.dart';

class PubRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<Pub> getPub() async {
    DocumentSnapshot doc =
        await _db.collection('pub_banner').doc("pub_banner_acceuil").get();
    return Pub.fromMap(doc.data() as Map<String, dynamic>);
  }
}
