import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class ActivateEmailAlert extends StatelessWidget {
  final String? username;
  const ActivateEmailAlert({
    required this.username,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      surfaceTintColor: Colors.green,
      child: Container(
        height: Get.height * 0.4,
        width: Get.width,
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(PixelArtIcons.close),
                )
              ],
            ),
            Text(
              "Dear $username",
              style: GoogleFonts.pressStart2p(),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "Please check your email and activate your account",
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(),
            ),
            const Spacer(
              flex: 1,
            ),
            SizedBox(
              width: Get.width * 0.4,
              child: ElevatedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    const BorderSide(width: 1.5, color: Colors.black),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  // overlayColor: MaterialStateProperty.all(Colors.white12),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Got it",
                        style: GoogleFonts.pressStart2p(),
                      ),
                      const Icon(PixelArtIcons.check),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
