import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/models/position.dart';
import 'package:rider_register/models/livraison.dart';
import 'package:dio/dio.dart';
import 'package:rider_register/repository/appareiluser_repository.dart';

class UserPostion {
  String? id;
  int? durationValue;

  UserPostion({this.id, this.durationValue});
}

class PositionRepository {
  // add the user to Firestore collection 'users'
  final _db = FirebaseFirestore.instance;

  final dio = Dio();
  final AppareilUserRepository appareilUserRepository =
      new AppareilUserRepository();

  Future<Map<String, dynamic>> getInfoTrajet(String latOrigin,
      String longOrigin, String latDesti, String longDesti) async {
    Response response;
    print("latOrigin : $latOrigin");
    print("longOrigin : $longOrigin");
    print("latDesti : $latDesti");
    print("longDesti : $longDesti");
    response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$latOrigin,$longOrigin&destinations=$latDesti,$longDesti&key=AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog");
    return response.data;
    // The below request is the same as above.
  }

  //listen change position on specific user
  Stream<Position> listenPosition(String iduser) {
    return _db
        .collection('positions')
        .where('iduser', isEqualTo: iduser)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Position.fromFirestore(doc.data()))
            .first);
  }

  //get X idrider near the position
  Future<List<String?>>
      getriderNearTheDeliveryLocationAndReturnTheTokenOfTheirPhone(
          String latDepartLivraison,
          String longitudeDepartLivraison,
          double money) async {
    //get all position of the rider
    List<Position> positions = [];
    List<String?> token = [];

    // Call getAllPositionWhereTimeUnderXminutes to get a list of positions
    List<Position> value = await getAllPositionWhereRiderIsActiveAndMoney(
        30, money); //await getAllPositionWhereTimeUnderXminutes(30);

    // Call getInfoTrajet for each position and add to idrider if duration < 15 mins
    List<Future> futures = [];
    for (Position position in value) {
      futures.add(getInfoTrajet(
        position.latitude.toString(),
        position.longitude.toString(),
        latDepartLivraison,
        longitudeDepartLivraison,
      ).then((value) async {
        print("value trajet info : $value");
        int durationValue =
            value['rows'][0]['elements'][0]['duration']['value'];
        print("durationValue : $durationValue");
        //if the duration is under 15 minutes
        if (durationValue < 900) {
          print("Rider added to list" + position.iduser.toString());
          String? tokentoadd = await appareilUserRepository
              .getTokenById(position.iduser.toString());
          print("tokentoadd : $tokentoadd");
          token.add(tokentoadd);
        }
      }));
    }
    await Future.wait(futures);

    return token;
  }

   Future<List<Position?>> getriderNearTheDeliveryLocation(
      String latDepartLivraison,
      String longitudeDepartLivraison,
      double money) async {
    // List to store positions and their associated durationValues
    List<Map<String, dynamic>> positionDurations = [];
  
    // Get all positions where the rider is active and meets the money condition
    List<Position> value = await getAllPositionWhereRiderIsActiveAndMoney(30, money);
  
    // Fetch durationValue for each position and store it with the position
    List<Future> futures = [];
    for (Position position in value) {
      futures.add(getInfoTrajet(
        position.latitude.toString(),
        position.longitude.toString(),
        latDepartLivraison,
        longitudeDepartLivraison,
      ).then((trajetInfo) async {
        print("value trajet info: $trajetInfo");
        int durationValue = trajetInfo['rows'][0]['elements'][0]['duration']['value'];
        print("durationValue: $durationValue");
        // Add position and durationValue to the list
        positionDurations.add({
          'position': position,
          'durationValue': durationValue,
        });
      }));
    }
    await Future.wait(futures);
  
    // Sort the positions by the lowest durationValue
    positionDurations.sort((a, b) => a['durationValue'].compareTo(b['durationValue']));
  
    // Extract the sorted positions
    List<Position> positions = positionDurations.map((e) => e['position'] as Position).toList();
  
    print("Final positions count: ${positions.length}");
    return positions;
  }

  Future<List<Position>> getAllPositionWhereTimeUnderXminutes(int minutes) {
    print("getAllPositionWhereTimeUnderXminutes");
    //List positions
    List<Position> positions = [];
    //get the current time
    Timestamp currenttime = Timestamp.now();

    //remove the minutes from the current time
    int timeXminutesAgo =
        currenttime.millisecondsSinceEpoch - (minutes * 60 * 1000);
    //convert the time to Timestamp
    Timestamp timeXminutesAgoTimestamp =
        Timestamp.fromMillisecondsSinceEpoch(timeXminutesAgo);
    //get all positions where the date is under the timeXminutesAgoTimestamp
    return _db
        .collection("positions")
        .where("date", isGreaterThan: timeXminutesAgoTimestamp)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        //add the positions to the list
        print(
            "thissss ${querySnapshot.docs[0].get("date").toDate().toString()}");
        querySnapshot.docs.forEach((element) {
          positions
              .add(Position.fromJson(element.data() as Map<String, dynamic>));
        });
      } else {
        print("no position found");
      }

      return positions;
    });
  }
//get list of id of rider where the money greater and is active
  Future<List<String>> getPositionIdsWhereRiderIsActiveAndMoney(double money) async {
  // Query the Firestore collection with the specified conditions
  final QuerySnapshot snapshot = await _db
      .collection("positions")
      .where("manaoVe", isEqualTo: "Eny")
      .where("volaInPoche", isGreaterThanOrEqualTo: money)
      .get();

  // Extract the document IDs from the query results
  final List<String> positionIds = snapshot.docs.map((doc) => doc.id).toList();

  // Return the list of document IDs
  return positionIds;
}
    Future<void> updateposition(double money ) async {
          List<String> idRider = [];
          if(money == 0){
            idRider = await getPositionIdsWhereRiderIsActive();
          }else{
            idRider = await getPositionIdsWhereRiderIsActiveAndMoney(money);
          }

          AppareilUserRepository appareilUserRepository = new AppareilUserRepository();
          for(String id in idRider){
            String? token = await appareilUserRepository.getTokenById(id);
            if(token != null){
              await appareilUserRepository.updateRiderPosition(token);
              
            }
          }
          // Wait 5 seconds 
          await Future.delayed(Duration(seconds: 5));
           return;


    }
 Future<List<String>> getPositionIdsWhereRiderIsActive() async {
  // Query the Firestore collection with the specified conditions
  final QuerySnapshot snapshot = await _db
      .collection("positions")
      .where("manaoVe", isEqualTo: "Eny")
      .get();

  // Extract the document IDs from the query results
  final List<String> positionIds = snapshot.docs.map((doc) => doc.id).toList();

  // Return the list of document IDs
  return positionIds;
}
  Future<List<Position>> getAllPositionWhereRiderIsActiveAndMoney(
      int minutes, double money) {
    print("getAllPositionWhereTimeUnderXminutes");
    //List positions
    List<Position> positions = [];
    //get the current time
    Timestamp currenttime = Timestamp.now();
    // currenttime.toDate().isAfter(other)
    //remove the minutes from the current time
    int timeXminutesAgo =
        currenttime.millisecondsSinceEpoch - (minutes * 60 * 1000);
    //convert the time to Timestamp
    Timestamp timeXminutesAgoTimestamp =
        Timestamp.fromMillisecondsSinceEpoch(timeXminutesAgo);
    //convert the time to Timestamp
    print("timestamp " + timeXminutesAgoTimestamp.toString());

    //get all positions where the date is under the timeXminutesAgoTimestamp
    if (money == -1.0) {
      return _db
          .collection("positions")
          .where("manaoVe", isEqualTo: "Eny")
          //.where("latitude", isNotEqualTo: 0)
          .where("date", isGreaterThan: timeXminutesAgoTimestamp)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          //add the positions to the list
          print(
              "thissss ${querySnapshot.docs[0].get("date").toDate().toString()}");
          querySnapshot.docs.forEach((element) {
            positions
                .add(Position.fromJson(element.data() as Map<String, dynamic>));
          });
        } else {
          print("no position found");
        }

        return positions;
      });
    } else {
      return _db
          .collection("positions")
          .where("manaoVe", isEqualTo: "Eny")
          .where("volaInPoche", isGreaterThanOrEqualTo: money)
          //.where("latitude", isNotEqualTo: 0)
          // .where("date", isGreaterThan: timeXminutesAgoTimestamp)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          //add the positions to the list
          print(
              "thissss ${querySnapshot.docs[0].get("date").toDate().toString()}");
          querySnapshot.docs.forEach((element) {
            print("kooo" + element.get("date").toDate().toString());
            print("kaaa " + timeXminutesAgoTimestamp.toDate().toString());

            if (element
                .get("date")
                .toDate()
                .isAfter(timeXminutesAgoTimestamp.toDate())) {
              print(" " + element.data().toString());
              positions.add(
                  Position.fromJson(element.data() as Map<String, dynamic>));
            }
            // positions
            //     .add(Position.fromJson(element.data() as Map<String, dynamic>));
          });
        } else {
          print("no position found");
        }
        print(positions.length);

        return positions;
      });
    }
  }
}
