// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_1/Models/user.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  void getUserModel() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get();

    _userModel = UserModel.fromDocumentSnapshot(documentSnapshot: userSnapshot);
  }

  void userTokenExists() {
    if (auth.currentUser != null) {
      getUserModel();
    }
  }
}
