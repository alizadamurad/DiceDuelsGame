import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_1/Controllers/ColorController/color_controller.dart';
import 'package:project_1/FriendsPage/components.dart';
import 'package:project_1/PlayerProfile/components.dart';

class PlayerProfile extends StatelessWidget {
  PlayerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    ColorController colorController = Get.find<ColorController>();
    return Stack(
      children: [
        Obx(
          () => Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // stops: [0.5, 0.5],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  colorController.color.value!,
                  const Color(0xffa3c1ad),
                  const Color(0xffe3ece6),
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Obx(
                      () => Hero(
                        tag: 'profile',
                        child: UserProfilePhoto(
                          size: 155,
                          color: colorController.color.value!,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Design",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                ProfileButton(
                  icon: Icons.color_lens_rounded,
                  text: "Change Color",
                  func: () {
                    Get.dialog(
                      ColorPickerDialog(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.func,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
  final void Function()? func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      onTap: func,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Colors.black.withAlpha(100),
            ),
            color: Colors.white.withOpacity(0.35),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        height: 70,
        width: Get.width * 0.85,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 30),
              child: Icon(
                icon,
                size: 30,
              ),
            ),
            Text(
              text,
              style: GoogleFonts.pressStart2p(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  ColorPickerDialog({super.key});

  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    ColorController colorController = Get.find<ColorController>();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: Get.height * 0.5,
        width: Get.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: BlockPicker(
              pickerColor: colorController.color.value!,
              onColorChanged: (value) {
                print("NORMAL COLOR :${colorController.color.value}");

                colorController.changeColor(value);
                print("CHANGED COLOR :${colorController.color.value}");
              },
              availableColors: colors,
            ),
          ),
        ),
      ),
    );
  }
}
