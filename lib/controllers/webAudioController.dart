import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/services.dart/YesNoDetection.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class WebAudioController extends GetxController {
  RxBool _hasSpeech = false.obs;
  bool _logEvents = false;
  RxDouble level = 0.0.obs;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  RxString lastWords = ''.obs;
  RxString lastError = ''.obs;
  RxString lastStatus = ''.obs;
  RxString _currentLocaleId = ''.obs;
  RxBool isListening = false.obs;

  final SpeechToText speech = SpeechToText();
  final cQuestions = Get.put(QuestionDetection());
  final cDialogflow = Get.put(DialogflowController());
  @override
  void onInit() {
    super.onInit();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: true,
    );
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId.value = systemLocale?.localeId ?? '';
    }
    _hasSpeech.value = hasSpeech;
  }

  void startListening() {
    showWaiting.value = true;
    cDialogflow.isButtonShowed.value = false;
    isListening.value = true;
    print('Started listening');
    lastWords.value = '';
    lastError.value = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 4),
        pauseFor: Duration(seconds: 4),
        partialResults: true,
        localeId: 'es_AR',
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        onDevice: true,
        listenMode: ListenMode.deviceDefault);
  }

  void stopListening() {
    AudioCache().play('done.mp3');
    _logEvent('stop');
    speech.stop();
    isListening.value = false;
    level.value = 0.0;
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    level.value = 0.0;
  }

  RxBool isYesNoBool = true.obs;
  void resultListener(SpeechRecognitionResult result) {
    print(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    lastWords.value = '${result.recognizedWords}';
    if (result.finalResult) {
      // audioPlayer.play('done.mp3');
      AudioPlayer().play('done.mp3', isLocal: true);

      stopListening();
      isListening.value = false;
      print('COMES IN SENDING TO QuestionDectection ');
      bool result = cQuestions.isYesNo(lastWords.value);
      if (result) {
        isYesNoBool.value = false;
        print('Yes NO Question');
      } else {
        responseDone.value = true;
        isYesNoBool.value = true;
        cDialogflow.sendMessage(lastWords.value);
      }
    }
  }

  void soundLevelListener(double levels) {
    minSoundLevel = min(minSoundLevel, levels);
    maxSoundLevel = max(maxSoundLevel, levels);
    level.value = levels;
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    lastError.value = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    lastStatus.value = '$status';
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }
}
