import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/main_view.dart';

class SplashScreenController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  Future<void> loggedIn() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    Get.to(MainView());
  }

  Future<void> notLoggedIn() async {
    Get.to(AuthView());
  }

  @override
  void onInit() async {
    await _authController.isAlreadyLoggedIn();
    if (_authController.isLoggedIn.value) {
      await loggedIn();
    } else {}
    super.onInit();
  }
}
