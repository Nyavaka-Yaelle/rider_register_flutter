import 'package:cloud_firestore/cloud_firestore.dart';

class FoodeeItem {
  String id;
  String name;
  String image;
  String description;
  String category;
  double price;
  DocumentReference restaurantId;
  String? restaurantName;
  int stock;

  FoodeeItem({
    required this.id,
    required this.name,
    required this.image,
    this.category = "",
    required this.description,
    required this.price,
    required this.restaurantId,
     this.restaurantName,
    required this.stock,
  });

  factory FoodeeItem.fromMap(Map<String, dynamic> map) {
    return FoodeeItem(
      id: map['id'] ?? "",
      name: map['name'],
      image: map['image'],
      category: map['category'],
      description: map['description'],
      price: map['price'],
      restaurantId: map['restaurant_id'],
      stock: map['stock'],
    );
  }
   // Méthode pour récupérer le nom du restaurant
  static Future<FoodeeItem> fromMapWithRestaurantName(
      Map<String, dynamic> map) async {
    final restaurantRef = map['restaurant_id'] as DocumentReference;
    String? restaurantName;

    try {
      final restaurantSnapshot = await restaurantRef.get();
      if (restaurantSnapshot.exists) {
        restaurantName = restaurantSnapshot['name'];
      }
    } catch (e) {
      print("Erreur lors de la récupération du restaurant : $e");
    }

    return FoodeeItem(
      id: map['id'] ?? "",
      name: map['name'],
      image: map['image'],
      category: map['category'] ?? "",
      description: map['description'],
      price: map['price'],
      restaurantId: restaurantRef,
      restaurantName: restaurantName, // Assigner le nom récupéré
      stock: map['stock'],
    );
  }
}
