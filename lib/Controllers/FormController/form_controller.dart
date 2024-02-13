import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get/get_rx/src/rx_types/rx_types.dart";
import "package:get/get_rx/src/rx_workers/rx_workers.dart";
import "package:get/get_state_manager/get_state_manager.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:project_1/AlertDialogs/confirm_email.dart";
import "package:project_1/Controllers/AuthController/auth_controller.dart";
import "package:project_1/SignInPage/sign_in_page.dart";
import "package:project_1/services/database.dart";

class FormX extends GetxController {
  final cloud = FirebaseFirestore.instance;

  RxBool isLoading = RxBool(false);

  // BUTTON CONTROLLER
  RxBool emailOK = RxBool(false);
  RxBool passOK = RxBool(false);
  RxBool repassOK = RxBool(false);
  RxBool usernameOK = RxBool(false);
  RxBool countryOK = RxBool(false);
  // RxBool activateButton = emailOK.value && passOK.value ? RxBool(true) : RxBool(false);

  // Password Eye Icon
  RxBool hidePass = RxBool(true);

  // Email and Password
  RxString email = RxString('');
  RxString password = RxString('');
  RxString repassword = RxString('');
  RxnString emailErrorText = RxnString(null);
  RxnString passwordErrorText = RxnString(null);
  RxnString rePasswordErrorText = RxnString(null);

  RxString country = RxString('');
  // Username
  RxString username = RxString('');
  RxnString errorText = RxnString(null);
  Rxn<Function()> submitFunc = Rxn<Function()>(null);

  @override
  void onInit() {
    super.onInit();
    debounce<String>(username, validations,
        time: const Duration(milliseconds: 0));
    debounce<String>(password, passValidation,
        time: const Duration(milliseconds: 0));

    debounce<String>(repassword, repassValidation,
        time: const Duration(milliseconds: 0));

    debounce<String>(email, emailValidation,
        time: const Duration(milliseconds: 0));
    // debounce<String>(country, countryValidation,
    //     time: const Duration(milliseconds: 0));
  }

  void changeCountry(var cntry) {
    country.value = cntry['name'];
    print(country.value);
    print(countryOK.value);
    countryOK.value = true;
  }

  // void countryValidation(var cntry) {
  //   countryOK.value = false;
  //   submitFunc.value = null;
  //   print(countryOK.value);
  //   if (cntry['name'].isNotEmpty) {
  //     countryOK.value = true;
  //     submitFunc.value = submitFunction();
  //   }
  // }
  // CLEAR TEXTFORMFIELDS

  // void clearForm() {
  //   email.value = "";
  //   password.value = "";
  //   repassword.value = "";
  //   username.value = "";
  // }

  // EMAIL CONTROLLER
  void emailValidation(String val) {
    emailOK.value = false;
    submitFunc.value = null;
    emailErrorText.value = null;
    if (val.isNotEmpty) {
      if (isEmail(val)) {
        emailOK.value = true;
        submitFunc.value = submitFunction();
        emailErrorText.value = null;
      }
    }
  }

  bool isEmail(String val) {
    if (!GetUtils.isEmail(val)) {
      emailErrorText.value = "Email is not valid";
      return false;
    }
    return true;
  }

  void emailChanged(String val) {
    email.value = val;
  }
  // EMAIL CONTROLLER

  // PASSWORD EYE CONTROLLER
  void toggleEye() {
    hidePass.value = !hidePass.value;
  }
  // PASSWORD EYE CONTROLLER

  // PASSWORD CONTROLLER
  bool passLenghtOk(String val, {int minLen = 6}) {
    if (val.length < minLen) {
      passwordErrorText.value = "Password is short";
      return false;
    }
    return true;
  }

  void passwordChanged(String val) {
    password.value = val;
  }

  void passValidation(String val) async {
    passOK.value = false;
    passwordErrorText.value = null;
    submitFunc.value = null;

    if (val.isNotEmpty) {
      if (passLenghtOk(val)) {
        submitFunc.value = submitFunction();
        passOK.value = true;
        passwordErrorText.value = null;
      }
    }
  }
  // PASSWORD CONTROLLER

  // REPASSWORD CONTROLLER
  void rePasswordChanged(String val) {
    repassword.value = val;
  }

  void repassValidation(String val) async {
    repassOK.value = false;
    rePasswordErrorText.value = null;
    submitFunc.value = null;

    if (val.isNotEmpty) {
      if (isSame(val)) {
        submitFunc.value = submitFunction();

        rePasswordErrorText.value = null;
        repassOK.value = true;
      }
    }
  }

  bool isSame(String val) {
    if (val != password.value) {
      rePasswordErrorText.value = "Passwords do not match";
      return false;
    }
    return true;
  }
  // REPASSWORD CONTROLLER

  void validations(String val) async {
    usernameOK.value = false;
    errorText.value = null;
    submitFunc.value = null;

    if (val.isNotEmpty) {
      if (lenghtOK(val) && await available(val)) {
        submitFunc.value = submitFunction();
        errorText.value = null;
        usernameOK.value = true;
      }
    }
  }

  bool lenghtOK(String val, {int minLen = 5}) {
    if (val.length < minLen) {
      errorText.value = "Username must be minimum 5 characters";
      return false;
    }
    return true;
  }

  Future<bool> available(String val) async {
    var userCollection = cloud.collection('users');
    final querySnapshot =
        await userCollection.where('username', isEqualTo: val).get();

    if (querySnapshot.docs.isNotEmpty) {
      errorText.value = "Username taken";
      return false;
    }
    return true;
  }

  void usernameChanged(String val) {
    username.value = val;
  }

  Future<bool> Function() submitFunction() {
    AuthController _authController = AuthController();
    DatabaseService _databaseService = DatabaseService();
    return () async {
      try {
        isLoading.value = true;
        // Get.dialog(
        //   barrierDismissible: false,
        //   Center(
        //     child: Lottie.asset(
        //       'assets/lotties/dice_loader.json',
        //       height: Get.height * 0.6,
        //       width: Get.width * 0.6,
        //     ),
        //   ),
        // );
        final user =
            await _authController.createAccountwithEmailandPasswordandUsername(
                email.value.trim(),
                password.value.trim(),
                username.value.trim());
        // String? name;
        // await Future(
        //   () {
        //     name = user?.displayName;
        //   },
        // );

        await _databaseService.createUser(user?.uid, username.value.trim(),
            country.value, 5000, true, 'profilePhoto', 'english');
        print(_databaseService.getUserStream(user?.uid));
        user?.sendEmailVerification();

        await Get.dialog(
          barrierDismissible: false,
          ActivateEmailAlert(
            username: username.value,
          ),
        );
        await _authController.signOut();

        isLoading.value = false;

        Get.off(() => SignIn());
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        // Get.back();

        Get.snackbar(
          "Error",
          '',
          dismissDirection: DismissDirection.horizontal,
          isDismissible: true,
          titleText: Text(
            "Something went wrong",
            style: GoogleFonts.pressStart2p(color: Colors.red[900]),
          ),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
          duration: const Duration(seconds: 4),
          barBlur: 25,
          borderRadius: 25,
          borderWidth: 2.5,
          borderColor: Colors.black,
          messageText: Text(
            e.message.toString(),
            style: GoogleFonts.pressStart2p(),
          ),
        );
      }
      return true;
    };
  }
}

// class FormSignInX extends GetxController{
//   final formKey = GlobalKey<FormState>();

//   // RxBool emailOK = RxBool(false);
//   // RxBool passOK =  RxBool(false);

//   // RxString email = RxString('');
//   // RxString pass = RxString('');

//   // void onInit(){
//   //   super.onInit();
//   //   //debounce thing;
//   // }

//   // void emailChanged(String val){
//   //   email.value = val;
//   // }
//   // void passChanged(String val){
//   //   pass.value = val;
//   // }
// }

// class PageViewController extends GetxController {
//   final PageController pageController = PageController();

//   void navigatePage(int index) {
//     pageController.animateToPage(index,
//         duration: const Duration(seconds: 1), curve: Curves.easeInOut);
//   }
// }
