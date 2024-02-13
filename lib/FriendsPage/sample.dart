import 'package:cloud_firestore/cloud_firestore.dart';

streamUnseenRequests(String? userId) {
  return FirebaseFirestore.instance
      .collection('requests')
      .doc(userId)
      .collection('friendRequests')
      .where('seen', isEqualTo: false)
      .count()
      .get()
      .then((value) => value.count);
}
