
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notif.dart';

class NotifRepository {
  final _db = FirebaseFirestore.instance;

Future<void> makeNotifRead(String idlivraison) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshots = await _db
        .collection('notifs_user')
        .where('id_livraison', isEqualTo: idlivraison)
        .where('is_read', isEqualTo: false) // Only update if not already read
        .get();

    for (var doc in snapshots.docs) {
      await _db.collection('notifs_user').doc(doc.id).update({
        'is_read': true,
      });
    }
  } catch (e) {
    print("Error updating isRead status: $e");
    rethrow;
  }
}



  Future<List<Notif>> getNotifsById(String iduser) async {
  List<Notif> notifs = [];
  try {
    // Calculate the date 2 days ago
    DateTime twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));

    QuerySnapshot<Map<String, dynamic>> snapshots = await _db
        .collection('notifs_user')
        .where('id_user', isEqualTo: iduser)
        .where('date', isGreaterThanOrEqualTo: twoDaysAgo)
        .orderBy('date', descending: true)  // Order by date in descending order
        .get();

    for (var doc in snapshots.docs) {
      Map<String, dynamic> data = doc.data();
      Notif notif = Notif.fromMap(data);
      notifs.add(notif);
    }

    return notifs;
  } catch (e) {
    print("Error getting notifications: $e");
    rethrow;
  }
}


}