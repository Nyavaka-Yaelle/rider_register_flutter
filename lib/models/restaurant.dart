import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/models/packaging.dart';
import 'package:rider_register/models/restaurant_food_type.dart';

class Restaurant {
  String id;
  String name;
  String address;
  GeoPoint location;
  String profilePicture;
  bool isOpen;
  String bannerPicture;
  double stars;
  double mostExpensivePrice;
  DocumentReference packagingId;
  Packaging? packaging;
  DocumentReference restaurantFoodTypeRef;
  RestaurantFoodType? restaurantFoodType;
  double higherPrice;
  double lowerPrice;
  String? distanceFromOrigin;
  String? durationFromOrigin;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.profilePicture,
    required this.bannerPicture,
    required this.stars,
    required this.mostExpensivePrice,
    required this.packagingId,
    this.isOpen = false,
    this.packaging,
    required this.restaurantFoodTypeRef,
    this.restaurantFoodType,
    required this.higherPrice,
    required this.lowerPrice,
    this.distanceFromOrigin,
  });

  static Future<Restaurant> fromMap(Map<String, dynamic> map, String id) async {
    final restaurantFoodTypeSnapshot =
        await map['restaurant_food_type_ref'].get();
    RestaurantFoodType? restaurantFoodType;
    if (restaurantFoodTypeSnapshot.exists) {
      print("restaurant food tupe ${restaurantFoodTypeSnapshot.data()}");
      restaurantFoodType = RestaurantFoodType.fromMap(
        restaurantFoodTypeSnapshot.data() as Map<String, dynamic>,
      );
    }
    final packagingSnapshot = await (map['packaging_id']?.get() ??
        FirebaseFirestore.instance
            .collection('packaging')
            .doc('XslvYtKcSFD10ciC8z8U')
            .get());
    Packaging? packaging;
    if (packagingSnapshot.exists) {
      packaging = Packaging.fromMap(
        packagingSnapshot.data() as Map<String, dynamic>,
      );
    }
    return Restaurant(
      id: id,
      name: map['name'],
      address: map['address'],
      isOpen: map['is_open'],
      location: map['location'],
      profilePicture: map['profile_picture'],
      bannerPicture: map['banner_picture'],
      stars: map['stars'],
      mostExpensivePrice: map['most_expensive_price'],
      packagingId: map['packaging_id'],
      packaging: packaging,
      restaurantFoodTypeRef: map['restaurant_food_type_ref'],
      restaurantFoodType: restaurantFoodType,
      higherPrice: map['higher_price'],
      lowerPrice: map['lower_price'],
    );
  }

  static String getDollardSymbole(double mostExpensivePrice) {
    if (mostExpensivePrice < 20000.0) {
      return "\$";
    } else if (mostExpensivePrice < 30000.0) {
      return "\$\$";
    } else if (mostExpensivePrice < 40000.0) {
      return "\$\$\$";
    } else if (mostExpensivePrice < 50000.0) {
      return "\$\$\$\$";
    } else if (mostExpensivePrice >= 50000.0) {
      return "*KING*";
    }
    return "\$";
  }

  static String getDollardSymboleInverse(double mostExpensivePrice) {
    if (mostExpensivePrice < 20000.0) {
      return "\$\$\$\$";
    } else if (mostExpensivePrice < 30000.0) {
      return "\$\$\$";
    } else if (mostExpensivePrice < 40000.0) {
      return "\$\$";
    }
    return "\$";
  }

  static String getAveragePrice(double higherPrice, double lowerPrice) {
    return "${lowerPrice.toInt() / 1000}k-${higherPrice.toInt() / 1000}k";
  }
}
