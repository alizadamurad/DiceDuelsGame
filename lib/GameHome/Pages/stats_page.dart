import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Stats Page",
            style: GoogleFonts.pressStart2p(),
          ),
        )
      ],
    );
  }
}
