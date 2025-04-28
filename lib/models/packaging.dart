import 'package:cloud_firestore/cloud_firestore.dart';

class Packaging {
  String id;
  String name;
  String image;

  Packaging({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Packaging.fromMap(Map<String, dynamic> map) {
    return Packaging(
      id: map['id'] ?? "",
      name: map['name'],
      image: map['image'],
    );
  }
}
