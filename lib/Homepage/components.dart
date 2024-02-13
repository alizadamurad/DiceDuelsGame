import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class SignInWidget extends StatelessWidget {
  final double depth;
  final bool isActive;
  final Color rightShadowColor;
  final Color bottomShadowColor;
  final Color leftShadowColor;
  final Color borderColor;
  final Color buttonColor;
  final void Function() onTapDown;
  final void Function() onTapUp;
  final List<Widget> widgets;
  const SignInWidget({
    required this.isActive,
    required this.borderColor,
    required this.bottomShadowColor,
    required this.buttonColor,
    required this.leftShadowColor,
    required this.onTapDown,
    required this.onTapUp,
    required this.rightShadowColor,
    required this.widgets,
    super.key,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      buttonPosition: Position.fullBottom,
      depth: depth,
      border: Border.all(
        color: borderColor,
        width: 1.5,
      ),
      enabled: isActive,
      rightShadowColor: rightShadowColor,
      bottomShadowColor: bottomShadowColor,
      leftShadowColor: leftShadowColor,
      disabledColor: Colors.grey,
      color: buttonColor,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }
}
