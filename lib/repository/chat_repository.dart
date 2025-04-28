import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/models/config.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:rider_register/repository/livraison_repository.dart';

import 'appareiluser_repository.dart';

class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  void sendMessage(String chatId, String idRider, String senderId, String text) {
    _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    sendNotificationChat(idRider, text);  
  }

  void sendNotificationChat(String idRider, String text) async {
    //get actual livraison of the rider
    LivraisonRepository livraisonRepository = LivraisonRepository();
    String? idLivraison = await livraisonRepository.checkIfRiderHasDeliveryInProgress(idRider);
    //get token by idRider
    AppareilUserRepository appareilUserRepository = AppareilUserRepository();
    appareilUserRepository.getTokenById(idRider).then((value) {
      if(value != null){
        appareilUserRepository.sendNotifChat(text, idLivraison!, value);
      }
    });
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
