import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/controllers/sttController.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class SpeechBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SttController());
  }
}
