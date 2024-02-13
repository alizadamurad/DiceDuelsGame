import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_1/AlertDialogs/confirm_email.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';
import 'package:project_1/Homepage/components.dart';
import 'package:project_1/SignUpPage/sign_up_page.dart';

class ExpandedOrWidget extends StatelessWidget {
  const ExpandedOrWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "or",
            style: GoogleFonts.pressStart2p(),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(),
          ),
        ),
      ],
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: Get.width * 0.6,
      child: SignInWidget(
        isActive: true,
        borderColor: const Color(0xff3d6011),
        bottomShadowColor: const Color(0xff3d6011),
        buttonColor: Colors.white,
        leftShadowColor: Colors.grey,
        onTapDown: () {},
        onTapUp: () {
          Get.back();
          Get.to(
            () => SignUpPage(),
            transition: Transition.downToUp,
          );
        },
        rightShadowColor: const Color(0xff5f9120),
        widgets: [
          Center(
            child: AutoSizeText(
              "Create account",
              style: GoogleFonts.pressStart2p(
                fontSize: 15,
                color: Colors.black,
              ),
              maxLines: 1,
            ),
          ),
        ],
        depth: 5,
      ),
    );
  }
}

class SignInButton extends GetWidget<AuthController> {
  SignInButton({
    super.key,
    required GlobalKey<FormState> formkey,
    required TextEditingController email,
    required TextEditingController pass,
  })  : _formkey = formkey,
        _email = email,
        _pass = pass;

  final GlobalKey<FormState> _formkey;
  final TextEditingController _email;
  final TextEditingController _pass;

  @override
  Widget build(BuildContext context) {
    FormX formX = Get.find<FormX>();

    return SizedBox(
      height: 70,
      width: Get.width * 0.6,
      child: SignInWidget(
        isActive: true,
        borderColor: const Color(0xff3d6011),
        bottomShadowColor: const Color(0xff3d6011),
        buttonColor: Colors.black,
        leftShadowColor: Colors.grey,
        onTapDown: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_formkey.currentState!.validate()) {
            formX.isLoading.value = true;
            // print('validated ${_email.text.trim()},${_pass.text.trim()}');

            try {
              final user = await controller.signInWithEmailandPassword(
                  _email.text.trim(), _pass.text.trim());
              print(user?.emailVerified);
              if (user?.emailVerified == false) {
                Get.dialog(
                  barrierDismissible: false,
                  ActivateEmailAlert(
                    username: user?.displayName,
                  ),
                );
                controller.signOut();
                print(controller.user);
                formX.isLoading.value = false;
              } else {
                formX.isLoading.value = false;
                Get.back();
              }
            } on FirebaseAuthException catch (error) {
              Get.snackbar(
                "Error",
                '',
                titleText: Text(
                  "Something went wrong",
                  style: GoogleFonts.pressStart2p(color: Colors.red[900]),
                ),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
                duration: const Duration(seconds: 4),
                barBlur: 25,
                dismissDirection: DismissDirection.horizontal,
                borderRadius: 25,
                borderWidth: 2.5,
                borderColor: Colors.black,
                messageText: Text(
                  error.code.contains('INVALID_LOGIN_CREDENTIALS')
                      ? "Login credentials are invalid"
                      : error.message.toString(),
                  style: GoogleFonts.pressStart2p(),
                ),
              );
              formX.isLoading.value = false;
              print(formX.isLoading.value);
            }
          }
        },
        onTapUp: () {},
        rightShadowColor: const Color(0xff5f9120),
        widgets: [
          Text(
            "Sign in",
            style: GoogleFonts.pressStart2p(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
        depth: 5,
      ),
    );
  }
}
