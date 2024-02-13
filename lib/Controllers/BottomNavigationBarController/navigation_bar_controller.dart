import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BottomNavBarController extends GetxController {
  final RxInt _currentPage = RxInt(2);

  // final pageViewController = PageController(initialPage: 1);

  RxInt get currentPage => _currentPage;

  // void changePage(int index) {
  //   currentPage.value = index;
  //   pageViewController.animateToPage(
  //     index,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.ease,
  //   );
  // }
}
