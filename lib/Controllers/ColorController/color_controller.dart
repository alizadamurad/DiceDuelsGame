import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {
  Rx<Color?> color = Colors.purple[300].obs;

  void changeColor(Color newColor) {
    color.value = newColor;
  }
}
