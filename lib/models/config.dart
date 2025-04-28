import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  double? commissionApp;
  double? kmInitialCourse;
  double? prixInitialCourse;
  double? prixParKm;

  Config(
      {this.commissionApp,
      this.kmInitialCourse,
      this.prixInitialCourse,
      this.prixParKm});

  //Constructor with 0 parameters
  Config.empty();

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      commissionApp: map['commissionApp'] == null
          ? 0.0
          : (map['commissionApp']).toDouble(),
      kmInitialCourse: map['kmInitialCourse'] == null
          ? 0.0
          : (map['kmInitialCourse']).toDouble(),
      prixInitialCourse: map['prixInitialCourse'] == null
          ? 0.0
          : (map['prixInitialCourse']).toDouble(),
      prixParKm: map['prixParKm'] == null ? 0.0 : (map['prixParKm']).toDouble(),
    );
  }
}
