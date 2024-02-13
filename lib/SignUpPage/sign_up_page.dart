// import 'dart:async';
// import 'dart:ffi';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:project_1/Constants/constants.dart';
// import 'package:project_1/Controllers/AuthController/auth_controller.dart';
// import 'package:project_1/Controllers/AuthController/user_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';
import 'package:project_1/Homepage/components.dart';
import 'package:project_1/SignUpPage/drop_down.dart';
// import 'package:project_1/main.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FormX formX = Get.find<FormX>();

  @override
  void dispose() {
    formX.email.value = "";
    formX.password.value = "";
    formX.repassword.value = "";
    formX.username.value = "";
    formX.countryOK.value = false;

    super.dispose();
  }
  // final _emailController = TextEditingController();
  // final _passController = TextEditingController();
  // final _repassController = TextEditingController();
  // final _usernameController = TextEditingController();

  // @override
  // void dispose() {
  //   _emailController.clear();
  //   _usernameController.clear();
  //   _passController.clear();
  //   _repassController.clear();
  //   super.dispose();
  // }

  // const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    // final _formkey = GlobalKey<FormState>();

    // bool isActive = formX.submitFunc.value == null ? false : true;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: GoogleFonts.pressStart2p(),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            PixelArtIcons.arrow_left,
            size: 30,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              // key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(
                      () => TextFormField(
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //     RegExp("[a-zA-Z0-9]"),
                        //   ),
                        // ],
                        onChanged: formX.emailChanged,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.pressStart2p(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.transparent,
                        decoration: customInputDecoration(
                          labelText: "Email",
                          errorText: formX.emailErrorText.value,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(
                      () => TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z0-9]")),
                          LowerCaseTextFormatter(),
                        ],
                        onChanged: formX.usernameChanged,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.pressStart2p(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.transparent,
                        decoration: customInputDecoration(
                            labelText: "Username",
                            errorText: formX.errorText.value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(
                      () => TextFormField(
                        onChanged: formX.passwordChanged,
                        obscureText: formX.hidePass.value,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.pressStart2p(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.transparent,
                        decoration: customInputDecoration(
                          labelText: "Password",
                          errorText: formX.passwordErrorText.value,
                          iconBtn: IconButton(
                            onPressed: () {
                              formX.toggleEye();
                            },
                            icon: formX.hidePass.value
                                ? const Icon(PixelArtIcons.eye_closed)
                                : const Icon(PixelArtIcons.eye),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(
                      () => TextFormField(
                        onChanged: formX.rePasswordChanged,
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.pressStart2p(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.transparent,
                        decoration: customInputDecoration(
                          labelText: "Confirm password",
                          errorText: formX.rePasswordErrorText.value,
                        ),
                      ),
                    ),
                  ),
                  DropDownWidget(),
                  // const Spacer(),
                  formX.isLoading.value
                      ? Lottie.asset(
                          'assets/lotties/dice_loader.json',
                          height: 150,
                          width: 150,
                        )
                      : Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: SizedBox(
                              height: 70,
                              width: Get.width * 0.45,
                              child: Obx(
                                () => SignInWidget(
                                  depth: formX.emailOK.value &&
                                          formX.passOK.value &&
                                          formX.usernameOK.value &&
                                          formX.repassOK.value &&
                                          formX.countryOK.value
                                      ? 5
                                      : 0,
                                  isActive: formX.emailOK.value &&
                                      formX.passOK.value &&
                                      formX.usernameOK.value &&
                                      formX.repassOK.value &&
                                      formX.countryOK.value,
                                  buttonColor: formX.emailOK.value &&
                                          formX.passOK.value &&
                                          formX.usernameOK.value &&
                                          formX.repassOK.value &&
                                          formX.countryOK.value
                                      ? const Color.fromARGB(255, 0, 0, 0)
                                      : Colors.grey[600]!,
                                  borderColor: formX.emailOK.value &&
                                          formX.passOK.value &&
                                          formX.usernameOK.value &&
                                          formX.repassOK.value &&
                                          formX.countryOK.value
                                      ? const Color(0xff3d6011)
                                      : Colors.black,
                                  rightShadowColor: const Color(0xff5f9120),
                                  bottomShadowColor: const Color(0xff3d6011),
                                  leftShadowColor: Colors.grey,
                                  onTapDown: () {},
                                  onTapUp: formX.submitFunc.value ?? () {},
                                  widgets: [
                                    const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        PixelArtIcons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Sign up",
                                      style: GoogleFonts.pressStart2p(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  // const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
