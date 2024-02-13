import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:project_1/Constants/constants.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';
// import 'package:project_1/Homepage/components.dart';
import 'package:project_1/SignInPage/components.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    FormX formX = Get.find<FormX>();

    final _formkey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  AuthController _auth = AuthController();
                  await _auth.signOut();
                },
                icon: Icon(Icons.exit_to_app))
          ],
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              PixelArtIcons.arrow_left,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Sign in",
            style: GoogleFonts.pressStart2p(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _formkey,
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (val) => emailController.text = val,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.pressStart2p(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter an email";
                        }
                      },
                      controller: emailController,
                      decoration: customInputDecoration(
                        labelText: "Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: TextFormField(
                      onChanged: (val) => passController.text = val,
                      obscureText: true,
                      style: GoogleFonts.pressStart2p(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a password";
                        }
                      },
                      controller: passController,
                      decoration: customInputDecoration(
                        labelText: "Password",
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.pressStart2p(
                              color: Colors.black,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: kSizedBoxSpace,
                  ),
                  formX.isLoading.value
                      ? Lottie.asset(
                          'assets/lotties/dice_loader.json',
                          height: 150,
                          width: 150,
                        )
                      : SignInButton(
                          formkey: _formkey,
                          email: emailController,
                          pass: passController,
                        ),
                  SizedBox(
                    height: kSizedBoxSpace,
                  ),
                  ExpandedOrWidget(),
                  SizedBox(
                    height: kSizedBoxSpace,
                  ),
                  CreateAccountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
