import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:http/http.dart' as http;

import '../models/commande.dart';
import 'commande_repository.dart';

class AppareilUserRepository {
  final _auth = FirebaseAuth.instance;
  // add the user to Firestore collection 'users'
  final _db = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> addAppareilUser(String uid) async {
    String? token = await messaging.getToken();
    _db
        .collection('appareilusers')
        .doc(uid)
        .set({'iduser': uid, 'token': token}).then(
            (documentSnapshot) => print("Added Token with ID: $uid"));
  }

// Update rider active position
  Future<void> updateRiderPosition(String token) async {
       Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    var response = dio.post(
        'https://sendsilentnotification-uzlldreeqq-uc.a.run.app',
        data: {
          "registrationToken": token
        });
  }
  //insert notif user
  Future<void> insertNotifUser(String idlivraison , String iduser , String title, String text) async{
    try{
      DocumentReference docRef = await _db.collection('notifs_user').add({
        'id_user' : iduser,
        'id_livraison' : idlivraison,
        'title' : title,
        'text' : text,
        'date' : Timestamp.now(),
        'is_read' : false,
      });
    } catch (e) {
      print("Error adding Notif User to Firestore: $e");
      rethrow;
    }
  }
  //insert notif resto
  Future<void> insertNotifResto(String idCommmande, String title, String text) async{
    CommandeRepository commandeRepository = CommandeRepository();
    Commande commande = await commandeRepository.getCommandeById(idCommmande);
    try{
      DocumentReference docRef = await _db.collection('notifs_resto').add({
        'id_resto' : commande.restaurantId,
        'id_commande' : idCommmande,
        'title' : title,
        'text' : text,
        'date' : Timestamp.now(),
        'is_read' : false,
      });
    } catch (e) {
      print("Error adding Notif Resto to Firestore: $e");
      rethrow;
    }
  }

  //get token by id
  Future<String?> getTokenById(String id) {
    return _db
        .collection('appareilusers')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database She is Beautiful and She is ' +
            documentSnapshot.get('token'));
        return documentSnapshot.get('token');
      }
    });
    //return null;
  }

  //send notification
  void sendNotif(String title, String body, String idLivraison,
      List<String> tokens) async {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    // dio.options.headers["authorization"] =
    //     "Bearer ya29.a0AVvZVsqTHiX59Hz5cPt_EoYhemqe56a4aLhanIKoxURFNGHXaODQkJjlVK3ljnQQ0Z4MIphQ85YjofYpVay_hMTOSXJwgzvbBYZPPV0BuDErXx3sWYwNFZ09IYkuPoq9aODDd9ssPHVXrVl6BfUq3p2ygiy40Y8aCgYKAXMSARESFQGbdwaInloGR1yGbrSF_l4IGR3U5Q0166";

    var response = await dio.post(
        'https://sendnotif-uzlldreeqq-uc.a.run.app',
        data: {
          // "message": {
          //   "token": appareil,
          //   "data": {"idLivraison": idLivraison},
          //   "notification": {"title": title, "body": body}
          // }
          "title": title,
          "body": body,
          "idLivraison": idLivraison,
          "registrationToken": tokens
        });
  }
  //send notif to Restaurant

  //send Notification to single user
  void sendNotifToSingleUser(
      String title, String body, String idLivraison, String token) {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    var response = dio.post(
        'https://sendnotificationtosingleuser-uzlldreeqq-uc.a.run.app',
        data: {
          "title": title,
          "body": body,
          "idLivraison": idLivraison,
          "registrationToken": token
        });
  }

  Future<void> sendNotifChat( String body, String idLivraison, String token) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    await dio.post(
        'https://sendnotificationformessage-uzlldreeqq-uc.a.run.app',
        data: {
          "title": 'message venant de votre client',
          "body": body,
          "idLivraison": idLivraison,
          "registrationToken": token
        });
  }


}
