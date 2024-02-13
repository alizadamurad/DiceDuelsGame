// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   Rxn<User> _firebaseUser = Rxn<User>(null);

//   User? get user => _firebaseUser.value;

//   @override
//   void onInit() {
//     super.onInit();
//     _firebaseUser.bindStream(_auth.authStateChanges());
//   }

//   void createUser(String username, String email, String password) async {
//     try {

//     } catch (e) {}
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _firebaseauth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>(null);
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_firebaseauth.authStateChanges());
    // print(" STATUS ${_firebaseUser.value}");
    super.onInit();
  }

  Future<User?> createAccountwithEmailandPasswordandUsername(
      String email, String password, String username) async {
    UserCredential? userCredentials;
    try {
      userCredentials = await _firebaseauth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseauth.currentUser?.updateDisplayName(username);
      return userCredentials.user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      rethrow;
    }
  }

  Future<User?> signInWithEmailandPassword(
      String email, String password) async {
    UserCredential? userCredentials;
    try {
      userCredentials = await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredentials.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseauth.signInWithCredential(credential);
      return userCredential;
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseauth.signOut();
    await GoogleSignIn().signOut();
  }
}
