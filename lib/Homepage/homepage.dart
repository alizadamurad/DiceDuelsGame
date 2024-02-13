import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neopop/neopop.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/AuthController/user_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';
import 'package:project_1/FriendsPage/friend_search.dart';
import 'package:project_1/GameHome/game_homepage.dart';

// import 'package:project_1/GameHome/game_home_page.dart';
// import 'package:project_1/Controllers/FormController/form_controller.dart';
import 'package:project_1/Homepage/components.dart';
import 'package:project_1/Models/user.dart';
import 'package:project_1/SignInPage/sign_in_page.dart';
import 'package:project_1/UsernameAndCountry/username_and_country.dart';
import 'package:project_1/services/database.dart';
import 'package:project_1/services/game_home_services.dart';
// import 'package:project_1/SignUpPage/sign_up_page.dart';
import 'package:rive/rive.dart' as rive;

class HomePage extends StatelessWidget {
  HomePage({super.key});
  // final PageViewController pageViewController = Get.put(PageViewController());

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    UserController userController = Get.find<UserController>();
    FormX formX = Get.find<FormX>();

    return Scaffold(
      // backgroundColor: Color(0xffa3c1ad),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                // stops: [0.5, 0.5],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  Color(0xffa3c1ad),
                  Color(0xffe3ece6),
                ],
              ),
            ),
          ),
          const rive.RiveAnimation.asset(
            'assets/rives/slow_dice.riv',
            antialiasing: true,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: const SizedBox(),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Dice Duels",
                      style: GoogleFonts.pressStart2p(
                        // shadows: [
                        //   const Shadow(
                        //     offset: Offset(2, 2),
                        //     blurRadius: 50,
                        //   )
                        // ],
                        color: Color(0xff004444),
                        // color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          size: 0.8,
                          colors: [
                            Colors.black,
                            // Color(0xff007777),
                            Colors.white,
                            // Color(0xff007777),
                            Colors.black
                          ],
                          delay: const Duration(seconds: 5),
                          duration: const Duration(seconds: 3),
                        )
                        .animate()
                        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                        .slide(
                          duration: const Duration(seconds: 2),
                        ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => SizedBox(
                    height: 70,
                    width: Get.width * 0.8,
                    child: GestureDetector(
                      onTapCancel: () {},
                      child: NeoPopTiltedButton(
                        enabled: authController.user != null ? true : false,
                        decoration: NeoPopTiltedButtonDecoration(
                            color: const Color(0xffffe22d),
                            plunkColor: const Color(0xffc3a13b),
                            shadowColor: Colors.grey[500]!.withOpacity(0.7),
                            showShimmer: true,
                            shimmerColor: Colors.white,
                            shimmerDuration: const Duration(seconds: 2),
                            shimmerDelay: const Duration(seconds: 10),
                            border: Border.all(
                              width: 0.6,
                              color: Colors.black,
                            )
                            // shimmerPlunkColor: Colors.yellowAccent[800],
                            ),
                        onTapUp: authController.user == null
                            ? () {}
                            : () {
                                Get.to(() => GameHomePage());
                                print('hello');
                              },
                        onTapDown: () {},
                        buttonDepth: 8,
                        isFloating: true,
                        shadowDistance: 18,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Play",
                                style: GoogleFonts.pressStart2p(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                ),
                              ),
                              const Icon(
                                PixelArtIcons.play,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => SizedBox(
                          height: 70,
                          width: Get.width * 0.40,
                          child: SignInWidget(
                            depth: 5,
                            isActive: true,
                            buttonColor: Colors.black,
                            borderColor: const Color(0xff3d6011),
                            rightShadowColor: const Color(0xff5f9120),
                            bottomShadowColor: const Color(0xff3d6011),
                            leftShadowColor: Colors.grey,
                            onTapDown: () {
                              print('a');
                            },
                            onTapUp: () {
                              Get.to(
                                () => SignIn(),
                                transition: Transition.downToUp,
                              );
                            },
                            widgets: authController
                                        .user?.providerData.first.providerId !=
                                    'password'
                                ? [
                                    const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Email",
                                      style: GoogleFonts.pressStart2p(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    )
                                  ]
                                : [
                                    const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 25,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Flexible(
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text: "Connected",
                                          style: GoogleFonts.pressStart2p(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 70,
                          width: Get.width * 0.40,
                          child: SignInWidget(
                            depth: 5,
                            isActive: true,
                            borderColor: Colors.black,
                            rightShadowColor:
                                const Color.fromARGB(255, 189, 188, 188),
                            bottomShadowColor: const Color(0xff8a8a8a),
                            buttonColor: Colors.white,
                            leftShadowColor: Colors.grey,
                            onTapDown: () {},
                            onTapUp: () async {
                              formX.isLoading.value = true;
                              UserCredential? userCredential =
                                  await authController.signInWithGoogle();
                              formX.isLoading.value = false;
                              if (userCredential?.user != null) {
                                DatabaseService databaseService =
                                    DatabaseService();
                                if (await databaseService
                                    .checkIfUserExistsInDatabase(
                                        userCredential?.user)) {
                                  // DocumentSnapshot<Map<String, dynamic>>
                                  //     userSnapshot = await FirebaseFirestore
                                  //         .instance
                                  //         .collection('users')
                                  //         .doc(auth.currentUser?.uid)
                                  //         .get();
                                  userController.getUserModel();

                                  print("DATA EXISTS");

                                  // userController.newUser(
                                  //     UserModel.fromDocumentSnapshot(
                                  //         documentSnapshot: userSnapshot));
                                  // print("USER MODEL DATA ${userModel?.points}");
                                  // Get.to(() => const GameHomePage());
                                } else {
                                  Get.to(() => UsernameAndCountryPage());
                                  print("DATA NEEDED NOT PERMITED");
                                }
                              } else {}
                            },
                            widgets: formX.isLoading.value
                                ? [
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  ]
                                : authController.user?.providerData.first
                                            .providerId !=
                                        'google.com'
                                    ? [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Logo(
                                            Logos.google,
                                            size: 25,
                                          ),
                                        ),
                                        Text(
                                          "Google",
                                          style: GoogleFonts.pressStart2p(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ]
                                    : [
                                        const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.done_rounded,
                                            size: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Flexible(
                                          child: RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: "Connected",
                                              style: GoogleFonts.pressStart2p(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Text(
                                        //   "Connected",
                                        //   style: GoogleFonts.pressStart2p(
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                      ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 70,
                        width: Get.width * 0.4,
                        child: NeoPopTiltedButton(
                          decoration: NeoPopTiltedButtonDecoration(
                            color: Colors.grey[600]!,
                            plunkColor: Colors.grey[400],
                            shadowColor: Colors.grey[800]!.withOpacity(0.5),
                            border: Border.all(
                              width: 0.8,
                              color: Colors.black,
                            ),
                          ),
                          onTapUp: () {},
                          onTapDown: () {
                            // auth.
                            // print(authController
                            //     .user?.providerData[0].providerId);
                            // print(authController.user?.displayName);
                            // HapticFeedback.vibrate();
                            // userController.newUser(userModel);
                            print(userController.userModel?.toJson());
                            // print(userModel?.countryName);
                            // print(userModel?.countryFlagCode);
                            // print(userModel?.points);
                            // print(userModel?.username);
                            // print("${authController?.user?.metadata}");
                          },
                          buttonDepth: 8,
                          isFloating: true,
                          shadowDistance: 18,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
