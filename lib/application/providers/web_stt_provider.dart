import 'dart:developer';
import 'dart:math' show min, max;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:questions_by_ottaa/application/providers/dialog_flow_provider.dart';
import 'package:questions_by_ottaa/core/repository/language_repository.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';
import 'package:questions_by_ottaa/core/services/questions_service.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class WebSTTProvider extends ChangeNotifier implements SttRepository {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _currentLocaleId = 'es-AR';
  String lastState = 'done';

  @override
  String text = '';

  @override
  String error = '';
  @override
  bool isRecognizing = false;
  @override
  bool isQuestion = false;

  final SpeechToText speech = SpeechToText();
  final QuestionsService questionsService;
  final LanguageRepository languageRepository;

  WebSTTProvider({
    required this.questionsService,
    required this.languageRepository,
  }) {
    initSpeechState();
  }
  Future<void> initSpeechState() async {
    _hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: true,
    );
    if (_hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }
  }

  @override
  Future<void> startRecording() async {
    print('Started listening');
    error = '';
    text = '';

    await speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 4),
      pauseFor: const Duration(seconds: 4),
      partialResults: true,
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      onDevice: true,
      listenMode: ListenMode.deviceDefault,
    );

    isRecognizing = true;
    notifyListeners();
  }

  @override
  Future<void> stopRecording() async {
    final uri = await AudioCache().load('done.mp3');

    final player = AudioPlayer();
    await player.play(DeviceFileSource(uri.path));

    // await player.stop();
    _logEvent('stop');
    speech.stop();
    isRecognizing = false;
    level = 0.0;
    notifyListeners();
  }

  void resultListener(SpeechRecognitionResult result) async {
    print('Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    text = result.recognizedWords;
    notifyListeners();
    if (result.finalResult) {
      isQuestion = questionsService.isYesNo(text);
      await languageRepository.save(text);
    }
  }

  void soundLevelListener(double levels) {
    minSoundLevel = min(minSoundLevel, levels);
    maxSoundLevel = max(maxSoundLevel, levels);
    level = levels;
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent('Received error status: $error, listening: ${speech.isListening}');
    this.error = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) async {
    _logEvent('Received listener status: $status, listening: ${speech.isListening}');
    if (status == 'done' && lastState == 'notListening') {
      await stopRecording();
    }
    try {
      notifyListeners();
    } catch (_) {}

    lastState = status;
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    log('$eventTime $eventDescription');
  }
}

final webSTTProvider = ChangeNotifierProvider<WebSTTProvider>((ref) {
  final questionsService = GetIt.I<QuestionsService>();
  final languageRepository = ref.watch<DialogFlowProvider>(dialogFlowProvider);

  return WebSTTProvider(
    questionsService: questionsService,
    languageRepository: languageRepository,
  );
});
