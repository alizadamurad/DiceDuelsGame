import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(String? userId, String username, String country,
      double points, bool online, String profilePhoto, String language) async {
    await firebaseAuth.currentUser?.updateDisplayName(username);

    await _firestore.collection('users').doc(userId).set({
      'username': username,
      'country': country,
      'points': points,
      'online': online,
      'profile_photo': profilePhoto,
      'language': language,
      'gift_codes': {
        'limit': null, // Set your default value
        'generated_by': null,
        'points': null,
        'code': null,
      },
      'generated_codes': {
        'code': null,
      },
      'inventory': {
        'matchPass': null,
      },
    });
  }

  Future<void> updateGiftCodes(
      String? userId, Map<String, dynamic> giftCodes) async {
    await _firestore.collection('users').doc(userId).update({
      'gift_codes': giftCodes,
    });
  }

  // Add other update methods for generated_codes and inventory

  // Example of how to listen for changes
  Stream<DocumentSnapshot> getUserStream(String? userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<bool> checkIfUserExistsInDatabase(User? user) async {
    if (user == null) return false;

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    return snapshot.exists;
  }

  Future<String?> getUserUsername(String? userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['username'];
      } else {
        return null; // User document doesn't exist
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Search users for friend requests
  Future<List<String>> searchUsers(String query) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final result = await usersRef
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username',
            isLessThan:
                query + 'z') // Assuming usernames are sorted lexicographically
        .get();

    final userList =
        result.docs.map((doc) => doc['username'] as String).toList();
    return userList;
  }
}
