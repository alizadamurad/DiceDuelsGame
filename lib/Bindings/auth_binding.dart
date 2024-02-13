import 'package:get/get.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/Controllers/AuthController/user_controller.dart';
import 'package:project_1/Controllers/BottomNavigationBarController/navigation_bar_controller.dart';
import 'package:project_1/Controllers/ColorController/color_controller.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<FormX>(FormX(), permanent: false);
    Get.put<BottomNavBarController>(BottomNavBarController());
    Get.put<UserController>(UserController());
    Get.put<ColorController>(ColorController());
  }
}
