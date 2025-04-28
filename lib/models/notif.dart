import 'package:cloud_firestore/cloud_firestore.dart';

class Notif {
  String idlivraison;
    String iduser;
  String title;
  String text;
  bool isRead;
  String? fromWhen;
  Timestamp date;

  String getTimeAgo(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime = timestamp.toDate();

    Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  Notif({
    required this.idlivraison,
    required this.iduser,
    required this.title,
    required this.text,
    required this.date,
    required this.isRead,
    this.fromWhen
  });

 factory Notif.fromMap(Map<String, dynamic> map) {
    Timestamp timestamp = map['date'];
    DateTime now = DateTime.now();
    DateTime dateTime = timestamp.toDate();
    Duration difference = now.difference(dateTime);

    String calculatedFromWhen;
    if (difference.inDays > 0) {
      calculatedFromWhen = 'il y a ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}';
    } else if (difference.inHours > 0) {
      calculatedFromWhen = 'il y a ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}';
    } else if (difference.inMinutes > 0) {
      calculatedFromWhen = 'il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      calculatedFromWhen = 'maintenant';
    }

    return Notif(
      idlivraison: map['id_livraison'],
        iduser: map['id_user'],
      title: map['title'],
      text: map['text'],
      date: timestamp,
      isRead: map['is_read'],
      fromWhen: calculatedFromWhen,
    );
  }

}
