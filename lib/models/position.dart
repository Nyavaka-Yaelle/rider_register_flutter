import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  Timestamp? date;
  String? iduser;
  String? longitude;
  String? latitude;
  bool? active;
  double? volainpoche;
  List<double>? rotation;

  Position(
      {required this.date,
      required this.iduser,
      required this.longitude,
      required this.latitude,
      this.rotation,
      this.active,
      this.volainpoche});

  Position.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    iduser = json['iduser'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    active = json['active'];
    rotation = (json['rotation'] as List<dynamic>?)?.cast<double>() ?? [];

    volainpoche = json['volainpoche'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['iduser'] = iduser;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['active'] = active;
    data['volainpoche'] = volainpoche;
    data['rotation'] = rotation;

    return data;
  }

  static fromFirestore(Map<String, dynamic> data) {
    return Position(
      date: data['date'],
      iduser: data['iduser'],
      longitude: data['longitude'],
      latitude: data['latitude'],
      active: data['active'],
      volainpoche: data['volainpoche'],
      rotation: (data['rotation'] as List<dynamic>?)?.cast<double>(),
    );
  }
}
