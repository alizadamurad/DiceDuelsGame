import 'package:awesome_bottom_bar/widgets/inspired/convex_shape.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.black,
          border: Border.all(
            width: 1,
            color: Colors.grey.withAlpha(200),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(-5, 5),
              color: Colors.black.withAlpha(200),
              blurRadius: 7,
            ),
            BoxShadow(
              offset: const Offset(5, 5),
              color: Colors.black.withAlpha(200),
              blurRadius: 7,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          // notchMargin: 0,
          height: 85,
          surfaceTintColor: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                  func: () {
                    pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                  },
                  icon: const Icon(
                    PixelArtIcons.chart,
                    color: Colors.white,
                  ),
                  text: 'Stats'),
              NavBarItem(
                func: () {
                  pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                },
                icon: const Icon(
                  PixelArtIcons.coin,
                  color: Colors.white,
                ),
                text: 'Shop',
              ),
              const SizedBox(
                width: 20,
              ),
              NavBarItem(
                  func: () {
                    pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                  },
                  icon: const Icon(
                    Icons.local_play_rounded,
                    color: Colors.white,
                  ),
                  text: "Spin"),
              NavBarItem(
                  func: () {
                    pageController.animateToPage(3,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                  },
                  icon: const Icon(
                    PixelArtIcons.users,
                    color: Colors.white,
                  ),
                  text: "Friends")
            ],
          ),
          // shape: CircularNotchedRectangle(),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.icon,
    required this.text,
    required this.func,
  });

  final Icon icon;
  final String text;
  final void Function()? func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: func,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: icon,
            ),
            Text(
              text,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
