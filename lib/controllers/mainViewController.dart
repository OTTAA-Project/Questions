import 'dart:developer';

import 'package:get/get.dart';

class MainViewController extends GetxController {
  @override
  void onInit() {
    log('onInit Called MainViewController');
    super.onInit();
  }

  Rx<double> left = (Get.size.width * 0.42).obs;
  Rx<double> top = (Get.size.height / 2).obs;

  Rx<bool> isListening = false.obs;
  Rx<String> text = ''.obs;
  Rx<double> confidence = 1.0.obs;
}
