import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantFoodType {
  String id;
  String name;

  RestaurantFoodType({
    required this.id,
    required this.name,
  });

  factory RestaurantFoodType.fromMap(Map<String, dynamic> map) {
    return RestaurantFoodType(
      //id: map['id'],
      id: 'test',
      name: map['name'],
    );
  }
}
