import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:flutter_session_manager/flutter_session_manager.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  // add the user to Firestore collection 'users'
  final _db = FirebaseFirestore.instance;

//constructor
  UserRepository();
  //update user password in firestore databse by phone number
  Future<void> updateUserPasswordByPhoneNumber(
      String phoneNumber, String password) {
    return _db
        .collection('users')
        .where("phone_number", isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        return _db
            .collection('users')
            .doc(querySnapshot.docs[0].id)
            .update({'password': password});
      }
    });
  }


  //get password by phone number
  Future<String?> getPasswordByPhoneNumber(String phoneNumber) {
    return _db
        .collection('users')
        .where("phone_number", isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        return querySnapshot.docs[0].get('password');
      }
    });
  }
//get user by id
  Future<UserFire.User?> getUserById(String id) {
    UserFire.User? user;
    return _db
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database She is Beautiful and She is ' +
            documentSnapshot.get('display_name'));
                  final data = documentSnapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        print('data is ' + data.toString());
        return UserFire.User(
          displayName: documentSnapshot.get('display_name'),
           firstName:  data != null && data.containsKey('first_name') && data?['first_name']!="Shikanoko"
            ? data['first_name'] :
             documentSnapshot.get('display_name').trim().substring(0, documentSnapshot.get('display_name').trim().lastIndexOf(' ')) ,
           
             lastName: data != null && data.containsKey('last_name') && data?['last_name']!="Nokonoko"
           ?  data['last_name']:
             documentSnapshot.get('display_name').trim().split(' ').last,

          phoneNumber: documentSnapshot.get('phone_number'),
          isRider: documentSnapshot.get('isrider'),
          email: documentSnapshot.get('email'),
          password: documentSnapshot.get('password'),
 profilePicture: data != null && data.containsKey('profile_picture')
            ? data['profile_picture']
            : "https://static.wikia.nocookie.net/shikanoko-nokonoko-koshitantan/images/1/11/Noko_Shikanoko.png/revision/latest/smart/width/386/height/259?cb=20240313114031",
      );
      }
    });
    //return null;
  }

  Future<UserFire.Rider?> getRiderByUserById(String id) async {
    final userDocument = await _db.collection('users').doc(id).get();

    if (userDocument.exists) {
      final riderDocument = await _db.collection('riders').doc(id).get();
      double moyenneNote = await calculateMoyenneNoteByIdRider(id);

      final now = DateTime.now();
      final last7Days = now.subtract(Duration(days: 7));

      final querySnapshot = await FirebaseFirestore.instance
          .collection('livraisons')
          .where('dateenregistrement', isGreaterThan: last7Days)
          .where('statut', isEqualTo: 'Arrived')
          .where('idrider', isEqualTo: id)
          .get();

      final nombreLivraisonsArrived = querySnapshot.size;
      if (riderDocument.exists) {
        var profilePicture = riderDocument.get('profile_picture');
        if (profilePicture is List<dynamic> && profilePicture.isNotEmpty) {
          profilePicture = profilePicture.first;
        }
        return UserFire.Rider(
          displayName: userDocument.get('display_name'),
          phoneNumber: userDocument.get('phone_number'),
          isRider: userDocument.get('isrider'),
          email: userDocument.get('email'),
          password: userDocument.get('password'),
          profilePicture: profilePicture,
          vehicleLicencePlate: riderDocument.get('vehicule_licence_plate'),
          vehicleType: riderDocument.get('vehicule_type'),
          moyenneNote: moyenneNote,
          nombreLivraisonsArrived: nombreLivraisonsArrived,
        );
      }
    }

    return null; // Return null if either user or rider document doesn't exist.
  }

  Future<int> getNombreLivraisonsDerniers7Jours() async {
    final now = DateTime.now();
    final last7Days = now.subtract(Duration(days: 7));

    final querySnapshot = await FirebaseFirestore.instance
        .collection('livraisons')
        .where('date_livraison', isGreaterThan: last7Days)
        .get();

    return querySnapshot.size;
  }

  Future<double> calculateMoyenneNoteByIdRider(String idRider) async {
    final querySnapshot = await _db
        .collection('notes')
        .where('idrider', isEqualTo: idRider)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      double somme = 0;
      for (var doc in querySnapshot.docs) {
        somme += doc.get('note');
      }
      double moyenne = somme / querySnapshot.docs.length;
      print('moyenne is ' + moyenne.toString());
      return moyenne;
    }

    return 0;
  }

  Future<void> updateUserById(String id, UserFire.User user) {
    return _db.collection('users').doc(id).update({
      'display_name': user.displayName,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'profile_picture': user.profilePicture,
    }).then((value) => null);
  }

  Future<void> updateuserpassword(String id, String password) {
    return _db
        .collection('users')
        .doc(id)
        .update({'password': password}).then((value) => null);
  }

//get user by username and password
  Future<UserFire.User?> getUserWithUsernameAndPassword(
      String username, String password) {
    UserFire.User? user;
    //print the username and password
    print("username is " + username);
    print("password is " + password);
    return _db
        .collection('users')
        .where("display_name", isEqualTo: username)
        .where("password", isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        print('Document exists on the database She is Beautiful and She is ' +
            querySnapshot.docs[0].get('display_name'));
        return UserFire.User(
            displayName: querySnapshot.docs[0].get('display_name'),
            phoneNumber: querySnapshot.docs[0].get('phone_number'),
            isRider: querySnapshot.docs[0].get('isrider'),
            email: querySnapshot.docs[0].get('email'),
            password: querySnapshot.docs[0].get('password'));
      }
    });
    //return null;
  }

//get username by phone number and password
//get user by username and password
  Future<UserFire.User?> getUserWitPhoneNumber(
      String phonenumber, String password) {
    return _db
        .collection('users')
        .where("phone_number", isEqualTo: phonenumber)
        .where("password", isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        return UserFire.User(
            displayName: querySnapshot.docs[0].get('display_name'),
            phoneNumber: querySnapshot.docs[0].get('phone_number'),
            isRider: querySnapshot.docs[0].get('isrider'),
            email: querySnapshot.docs[0].get('email'),
            password: querySnapshot.docs[0].get('password'));
      }
    });
    //return null;
  }

//get current user
  User? getCurrentUser() {
    print("getting current user");
    print(_auth.currentUser?.uid);
    return _auth.currentUser;
  }

// function to store the user in Firestore
  Future<void> addUser(String uid, UserFire.User user) async {
    _db.collection('users').doc(uid).set({
      'display_name': user.displayName,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone_number': user.phoneNumber,
      'isrider': user.isRider,
      'email': user.email,
      'password': user.password,
    }).then((documentSnapshot) => print("Added Data with ID: $uid"));
    ;
  }

  Future<void> insertUserPositions(
      String uid, String latitude, String longitude, Timestamp date) async {
    _db.collection('positions').doc(uid).set({
      'latitude': latitude,
      'longitude': longitude,
      'iduser': uid,
      'date': date
    }).then((documentSnapshot) => print("Added Data with ID: $uid"));
    ;
  }

  Future<void> signOut() async {
    await SessionManager().remove("user");
    await _auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return _auth.currentUser!.uid;
  }
}
