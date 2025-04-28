import 'package:cloud_firestore/cloud_firestore.dart';

class Pub {
  String? pub1;
  String? pub2;
  String? pub3;
  String? link1;
  String? link2;
  String? link3;

  Pub({
    this.pub1,
    this.pub2,
    this.pub3,
    this.link1,
    this.link2,
    this.link3,
  });

  Pub.fromMap(Map<String, dynamic> map)
      : pub1 = map['pub1'],
        pub2 = map['pub2'],
        pub3 = map['pub3'],
        link1 = map['link1'],
        link2 = map['link2'],
        link3 = map['link3'];

  Map<String, dynamic> toMap() {
    return {
      'pub1': pub1,
      'pub2': pub2,
      'pub3': pub3,
      'link1': link1,
      'link2': link2,
      'link3': link3,
    };
  }
}
