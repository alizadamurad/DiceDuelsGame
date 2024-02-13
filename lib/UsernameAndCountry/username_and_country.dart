import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/Constants/constants.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';
import 'package:project_1/Homepage/components.dart';
import 'package:project_1/SignUpPage/drop_down.dart';
import 'package:project_1/services/database.dart';

class UsernameAndCountryPage extends StatefulWidget {
  const UsernameAndCountryPage({super.key});

  @override
  State<UsernameAndCountryPage> createState() => _UsernameAndCountryPageState();
}

class _UsernameAndCountryPageState extends State<UsernameAndCountryPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthController authController = AuthController();
  FormX formX = Get.find<FormX>();

  bool buttonClicked = false;

  @override
  void dispose() {
    formX.username.value = "";
    formX.country.value = "";
    formX.countryOK.value = false;
    formX.usernameOK.value = false;
    buttonClicked ? () : authController.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '${formX.usernameOK.value}   ${formX.usernameOK.value}  ${formX.usernameOK.value && formX.usernameOK.value}');
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.clamp,

              // transform: GradientRotation(5),
              // stops: [0.3, 0.9],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Color(0xffa3c1ad),
                Color(0xffe3ece6),
                Color(0xffa3c1ad),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   title: Text("Complate Sign "),
          // ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Welcome! Let's Get Started",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 20,
                      shadows: [
                        const Shadow(
                          blurRadius: 50,
                          color: Colors.white,
                          offset: Offset(2, 2),
                        )
                      ],
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
                DropDownWidget(),
                const Spacer(
                  flex: 4,
                ),
                Obx(
                  () => SizedBox(
                    height: 70,
                    width: Get.width * 0.8,
                    child: SignInWidget(
                      isActive: formX.usernameOK.value && formX.countryOK.value,
                      borderColor: Colors.black,
                      bottomShadowColor: Color.fromARGB(255, 187, 187, 187),
                      buttonColor:
                          formX.usernameOK.value && formX.countryOK.value
                              ? const Color(0xffe5cb28)
                              : Colors.grey,
                      leftShadowColor: Colors.grey,
                      onTapDown: () {},
                      onTapUp: formX.usernameOK.value && formX.countryOK.value
                          ? () async {
                              buttonClicked = true;
                              DatabaseService databaseService =
                                  DatabaseService();
                              await databaseService.createUser(
                                  firebaseAuth.currentUser?.uid,
                                  formX.username.value,
                                  formX.country.value,
                                  6000,
                                  true,
                                  'profilePhoto',
                                  'language');
                              Get.back();
                            }
                          : () {
                              print("button deactive");
                            },
                      rightShadowColor: Colors.white,
                      widgets: [
                        Text(
                          "Continue",
                          style: GoogleFonts.pressStart2p(
                            color: Colors.black,
                          ),
                        )
                      ],
                      depth: 6,
                      //  formX.usernameOK.value && formX.countryOK.value
                      //     ? 6
                      //     : 0,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
