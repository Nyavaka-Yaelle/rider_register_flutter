import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/restaurant.dart';

final _db = FirebaseFirestore.instance;

Future<List<Restaurant>> getRestaurants() async {
  QuerySnapshot querySnapshot =
      await _db.collection('restaurants').limit(10).get();
  List<Restaurant> restaurants = [];
  List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
  for (var doc in list) {
    //check if address is null
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data.containsKey("address")) {
      Restaurant restaurant = await Restaurant.fromMap(
          doc.data() as Map<String, dynamic>, doc.reference.id);
      restaurants.add(restaurant);
    }
  }
  return restaurants;
}

Future<List<Restaurant>> getRestaurantsOpen() async {
  QuerySnapshot querySnapshot = await _db
      .collection('restaurants')
      .where('is_open', isEqualTo: true)
      .get();
  List<Restaurant> restaurants = [];
  List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
  for (var doc in list) {
    //check if address is null
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data.containsKey("address")) {
      Restaurant restaurant = await Restaurant.fromMap(
          doc.data() as Map<String, dynamic>, doc.reference.id);
      restaurants.add(restaurant);
    }
  }
  return restaurants;
}

//make search function for restaurant name
Future<List<Restaurant>> searchRestaurants(String search) async {
  // Fetch all restaurant documents
  QuerySnapshot querySnapshot = await _db.collection('restaurants').get();

  // Filter the results in Dart code
  List<QueryDocumentSnapshot<Object?>> allRestaurants = querySnapshot.docs;
  List<Restaurant> filteredRestaurants = [];
  
  for (var doc in allRestaurants) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String name = data['name'].toString().toLowerCase();
    if (name.contains(search.toLowerCase())) {
      Restaurant restaurant = await Restaurant.fromMap(data, doc.reference.id);
      filteredRestaurants.add(restaurant);
    }
  }

  return filteredRestaurants;
}

Future<List<Restaurant>> getRestaurantsDistancedOrigins(String origin) async {
  var restaurants = await getRestaurantsOpen();
  try {
    List<String> destinations = [];
    List<String> origins = [];
    for (var item in restaurants) {
      destinations.add("${item.location.latitude},${item.location.longitude}");
      origins.add(origin);
    }
    final apiKey = 'AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog';
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?units=metric&origins=${origins.join("|")}&destinations=${destinations.join("|")}&language=fr&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);
    for (var i = 0; i < restaurants.length; i++) {
      var element = data['rows'][0]['elements'][i];
      if (element['status'] == 'OK') {
        restaurants[i].distanceFromOrigin = element['distance']['text'];
        restaurants[i].durationFromOrigin = element['duration']['text'];
      } else {
        restaurants[i].distanceFromOrigin = null;
        restaurants[i].durationFromOrigin = null;
      }
    }
  } catch (e) {
    print("Error get Restaurants Distanced Origins: $e");
  }
  return restaurants;
}

Future<Restaurant?> getRestaurantById(String restaurantId) async {
  try {
    DocumentSnapshot doc =
        await _db.collection('livraisons').doc(restaurantId).get();
    if (doc.exists) {
      return Restaurant.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.reference.id,
      );
    } else {
      print("Livraison with ID $restaurantId does not exist");
      return null;
    }
  } catch (e) {
    print("Error getting Livraison: $e");
    throw e;
  }
}
// get restaurant by DocumentReference
Future<Restaurant?> getRestaurantByReference(DocumentReference restaurantRef) async {
  try {
    DocumentSnapshot doc = await restaurantRef.get();
    if (doc.exists) {
      return Restaurant.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.reference.id,
      );
    } else {
      print("Restaurant with ID ${restaurantRef.id} does not exist");
      return null;
    }
  } catch (e) {
    print("Error getting Restaurant: $e");
    throw e;
  }
}
