import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/menu_item.dart';

class CartFoodeeItem {
  FoodeeItem foodeeItem;
  String note;
  int size;

  CartFoodeeItem({
    required this.foodeeItem,
    required this.note,
    required this.size,
  });
}
