import 'package:cloud_firestore/cloud_firestore.dart';

class FoodeeItem {
  String id;
  String name;
  String image;
  String description;
  String category;
  double price;
  DocumentReference restaurantId;
  int stock;

  FoodeeItem({
    required this.id,
    required this.name,
    required this.image,
    this.category = "",
    required this.description,
    required this.price,
    required this.restaurantId,
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
}
