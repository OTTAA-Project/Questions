// ignore_for_file: unused_import

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class TTSController extends GetxController {
  static final tts = FlutterTts();
  @override
  void onInit() {
    configureTTS();
    super.onInit();
  }

  configureTTS() async {
    print('configuring === TTS');
    await tts.setPitch(1);
    await tts.setLanguage('es-AR');
    await tts.awaitSpeakCompletion(true);
  }

  Future speak(String readAloud) async {
    print('its speaking =========== $readAloud');
    await tts.speak(readAloud);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
