import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/menu_item.dart';
import 'dart:math';

final _db = FirebaseFirestore.instance;
// get all menu items from the database
Future<List<FoodeeItem>> getAllItems() async {
  final QuerySnapshot snapshot = await _db.collection('menu_items').get();
  final List<FoodeeItem> items = [];
  snapshot.docs.forEach((doc) {
    final FoodeeItem item =
        FoodeeItem.fromMap(doc.data() as Map<String, dynamic>);
    item.id = doc.id;
    items.add(item);
  });

  return items;
}
//get 4 random list of Foodeeitem from the database

Future<List<FoodeeItem>> getXRandomItems(int number) async {
  final QuerySnapshot snapshot = await _db.collection('menu_items').get();
  final List<FoodeeItem> items = [];
  snapshot.docs.forEach((doc) {
    final FoodeeItem item =
        FoodeeItem.fromMap(doc.data() as Map<String, dynamic>);
    item.id = doc.id;
    if (item.stock > 0) {
      items.add(item);
    }
  });

  // Shuffle the list to get random items
  items.shuffle(Random());

  // Take the first 4 items from the shuffled list
  return items.take(number).toList();
}

//make search function for menu item name and description
Future<List<FoodeeItem>> searchMenuItems(String search) async {
  // Fetch all menu item documents
  QuerySnapshot querySnapshot = await _db.collection('menu_items').get();

  // Filter the results in Dart code
  List<QueryDocumentSnapshot> allMenuItems = querySnapshot.docs;
  List<FoodeeItem> filteredMenuItems = [];
  for (var doc in allMenuItems) {
    final FoodeeItem item =
        FoodeeItem.fromMap(doc.data() as Map<String, dynamic>);
    item.id = doc.id;
    if ((item.name.toLowerCase().contains(search.toLowerCase()) ||
        item.description.toLowerCase().contains(search.toLowerCase())) &&
        item.stock > 0) { // Add condition to check stock
      filteredMenuItems.add(item);
    }
  }

  return filteredMenuItems;
}


Future<List<FoodeeItem>> getFoodeeItemsByRestaurantId(
  String restaurantId,
) async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('menu_items')
      .where(
        'restaurant_id',
        isEqualTo: FirebaseFirestore.instance.doc("restaurants/$restaurantId"),
      )
      .get();

  final List<FoodeeItem> items = [];
  snapshot.docs.forEach((doc) {
    final FoodeeItem item =
        FoodeeItem.fromMap(doc.data() as Map<String, dynamic>);
    item.id = doc.id;
    items.add(item);
  });

  return items;
}
