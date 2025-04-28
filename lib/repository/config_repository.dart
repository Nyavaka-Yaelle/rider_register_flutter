import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/config.dart';

class ConfigRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

//get Config by id
  Future<Config> getConfigById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('config').doc(id).get();
      if (doc.exists) {
        return Config.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print("Config with ID $id does not exist");
        return Config.empty();
      }
    } catch (e) {
      print("Error getting Config: $e");
      throw e;
    }
  }
}
