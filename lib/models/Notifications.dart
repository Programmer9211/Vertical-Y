import 'package:cloud_firestore/cloud_firestore.dart';

void sendNotification(
    String documents, Map<String, dynamic> notificationmap) async {
  final CollectionReference collrefs = FirebaseFirestore.instance
      .collection('profile')
      .doc(documents)
      .collection('notify');

  await collrefs.add(notificationmap);
}
