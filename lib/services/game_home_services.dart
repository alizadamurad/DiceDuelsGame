import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project_1/Controllers/AuthController/auth_controller.dart';

// AuthController auth = AuthController();
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> increaseLevelPercentage(int increment) async {
  final userRef =
      FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid);

  try {
    final DocumentSnapshot userDoc = await userRef.get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      int currentPercentage = userData?['level_percentage'] ?? 0;
      currentPercentage += increment;

      await userRef.update({'level_percentage': currentPercentage});
      // Check if level threshold (100%) is crossed
      // if (currentPercentage >= 100) {
      //   int currentLevel = userDoc.data()?['level'] ?? 1;
      //   currentLevel++;
      //   await userRef.update({
      //     'level': currentLevel,
      //     'level_percentage': 0, // Reset level percentage after level up
      //   });
      // }
    }
  } catch (e) {
    print('Error increasing level percentage: $e');
    // Handle error
  }
}

Stream<int?> getCurrentLevelPercentageStream() {
  print(auth.currentUser?.uid);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .snapshots()
      .map((doc) => doc['level_percentage']);
}

Stream<int?> getCurrentLevelStream() {
  print(auth.currentUser?.uid);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .snapshots()
      .map((doc) => doc['level']);
}
