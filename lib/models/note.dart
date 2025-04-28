import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? idrider;
  String? idlivraison;
  double? note;
  String? commentaire;
  String? ameliorer;
  double? pourboire;

  Note({
    this.idrider,
    this.idlivraison,
    this.note,
    this.commentaire,
    this.ameliorer,
    this.pourboire,
  });

  Note.fromMap(Map<String, dynamic> map)
      : idrider = map['idrider'],
        idlivraison = map['idlivraison'],
        note = map['note'],
        commentaire = map['commentaire'],
        ameliorer = map['ameliorer'],
        pourboire = map['pourboire'];

  Map<String, dynamic> toMap() {
    return {
      'idrider': idrider,
      'idlivraison': idlivraison,
      'note': note,
      'commentaire': commentaire,
      'ameliorer': ameliorer,
      'pourboire': pourboire,
    };
  }
}
