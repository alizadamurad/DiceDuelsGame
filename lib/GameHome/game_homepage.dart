import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/AuthController/user_controller.dart';
import 'package:project_1/Controllers/BottomNavigationBarController/navigation_bar_controller.dart';
import 'package:project_1/Controllers/ColorController/color_controller.dart';
import 'package:project_1/FriendsPage/components.dart';
import 'package:project_1/GameHome/Pages/stats_page.dart';
import 'package:project_1/GameHome/bottom_nav_bar.dart';
import 'package:project_1/PlayerProfile/player_profile.dart';
import 'package:project_1/SpinnerPage/spinner_page.dart';
import 'package:project_1/UsernameAndCountry/username_and_country.dart';
import 'package:project_1/services/game_home_services.dart';
import 'package:project_1/FriendsPage/my_requests.dart';

class GameHomePage extends StatefulWidget {
  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  final pageViewWidgets = [
    StatsPage(),
    PlayMenu(),
    SpinnerPage(),
    MyFriendRequests(),
    // PlayerProfile(),
  ];

  // double? percent = 1;
  AuthController auth = Get.find<AuthController>();
  BottomNavBarController navController = Get.find<BottomNavBarController>();
  final pageViewController = PageController(initialPage: 1);

  // @override
  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            height: 100,
            width: 100,
            child: FloatingActionButton(
              mini: true,
              disabledElevation: 0,
              focusElevation: 0,
              mouseCursor: MouseCursor.defer,
              highlightElevation: 0,
              hoverElevation: 0,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              clipBehavior: Clip.none,
              elevation: 0,
              backgroundColor: Colors.transparent,
              onPressed: null,
              child: GestureDetector(
                onTap: () => pageViewController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
                child: HexagonWidget.pointy(
                  elevation: 20,
                  width: 70,
                  height: 70,
                  color: Colors.black,
                  child: HexagonWidget.pointy(
                    width: 63,
                    height: 63,
                    color: Colors.amber,
                    child: const Center(
                      child: Icon(
                        PixelArtIcons.play,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: NavBar(pageController: pageViewController),
          backgroundColor: Colors.transparent,
          body: PageView(
            // onPageChanged: (value) => navController.changePage(value),
            controller: pageViewController,
            children: pageViewWidgets,
          ),
        ),
      ],
    );
  }
}

class PlayMenu extends StatefulWidget {
  const PlayMenu({super.key});

  @override
  State<PlayMenu> createState() => _PlayMenuState();
}

class _PlayMenuState extends State<PlayMenu> {
  UserController userController = Get.find<UserController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AuthController auth = Get.find<AuthController>();
    ColorController colorController = Get.find<ColorController>();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${userController.userModel?.points.truncate()}\$",
                  style: GoogleFonts.pressStart2p(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey[700]!.withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => PlayerProfile()),
                        child: Obx(
                          () => Hero(
                            tag: 'profile',
                            child: SizedBox(
                              width: Get.width * 0.3,
                              child: UserProfilePhoto(
                                color: colorController.color.value!,
                                size: 110,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width * 0.57,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                "${userController.userModel?.username}",
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 15,
                                  color: Colors.white,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              bottom: 5,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Level",
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 13,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(5, 5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder<int?>(
                                    stream: getCurrentLevelStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return Text('${snapshot.error}');
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const Text('No data available');
                                      } else {
                                        int currentLevel = snapshot.data!;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            "$currentLevel",
                                            style: GoogleFonts.pressStart2p(
                                              fontSize: 13,
                                              color: Colors.white,
                                              shadows: const [
                                                Shadow(
                                                  offset: Offset(5, 5),
                                                  blurRadius: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                          StreamBuilder<int?>(
                              stream: getCurrentLevelPercentageStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Text('${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('No data available');
                                } else {
                                  int currentPercentage = snapshot.data!;
                                  return Tooltip(
                                    message: "$currentPercentage%",
                                    child: LinearPercentIndicator(
                                      width: 130,
                                      animation: true,
                                      lineHeight: 8,
                                      animationDuration: 1000,
                                      percent: currentPercentage / 100,
                                      // center: Text(
                                      //   "$currentPercentage",
                                      //   style: GoogleFonts.pressStart2p(
                                      //     fontSize: 9,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      barRadius: const Radius.circular(5),
                                      backgroundColor: Colors.white,
                                      linearGradient: LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.redAccent.withRed(200),
                                        ],
                                      ),
                                      // clipLinearGradient: true,
                                      // fillColor: Colors.black,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
