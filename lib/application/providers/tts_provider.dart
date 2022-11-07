import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:questions_by_ottaa/core/repository/tts_repository.dart';

class TTSProvider extends ChangeNotifier implements TTSRepository {
  final tts = FlutterTts();

  String language = 'es-AR'; //TODO: Detect
  List<dynamic> availableTTS = [];

  bool customTTSEnable = false;

  double speechRate = 0.4;
  double pitch = 1.0;

  TTSProvider() {
    initTTS();
  }

  @override
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      if (customTTSEnable) {
        await tts.setSpeechRate(speechRate);
        await tts.setPitch(pitch);
      }

      await tts.speak(text);
    }
  }

  Future<void> initTTS() async {
    await tts.setPitch(pitch);
    await tts.setSpeechRate(speechRate);
    await tts.setVolume(1.0);
    await tts.setLanguage(language);
    await tts.awaitSpeakCompletion(true);
    availableTTS = await tts.getLanguages;
  }
}

final ttsProvider = ChangeNotifierProvider<TTSProvider>((ref) {
  return TTSProvider();
});
