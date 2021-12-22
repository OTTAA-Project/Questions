import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/services.dart/YesNoDetection.dart';
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
  final SpeechToText speech = SpeechToText();
  RxBool isListening = false.obs;

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
    isListening.value = true;

    _logEvent('start listening');
    lastWords.value = '';
    lastError.value = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: 'es_AR',
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  void stopListening() {
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

      print('COMES IN SENDING TO DF ');
      bool result = cQuestions.isYesNo(lastWords.value);
      if(result)
          {
            isYesNoBool.value = false;
          print('Yes NO Question');
          }
          else{
        isYesNoBool.value = true;
        cDialogflow.sendMessage(lastWords.value);
      }
    }
  }

  void soundLevelListener(double levels) {
    minSoundLevel = min(minSoundLevel, levels);
    maxSoundLevel = max(maxSoundLevel, levels);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
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

// class RecognitionResultsWidget extends StatelessWidget {
//   const RecognitionResultsWidget({
//     Key? key,
//     required this.lastWords,
//     required this.level,
//   }) : super(key: key);

//   final String lastWords;
//   final double level;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Center(
//           child: Text(
//             'Recognized Words',
//             style: TextStyle(fontSize: 22.0),
//           ),
//         ),
//         Expanded(
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 color: Theme.of(context).selectedRowColor,
//                 child: Center(
//                   child: Text(
//                     lastWords,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 bottom: 10,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                             blurRadius: .26,
//                             spreadRadius: level * 1.5,
//                             color: Colors.black.withOpacity(.05))
//                       ],
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                     ),
//                     child: IconButton(
//                       icon: Icon(Icons.mic),
//                       onPressed: () => null,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
// Container(
//                                           decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Colors.white)),
//                                           constraints: BoxConstraints(
//                                               minHeight: 50.h,
//                                               minWidth: screenWidth),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(15.0),
//                                             child: Center(
//                                                 child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 AnswerCard(
//                                                   screenHeight: screenHeight,
//                                                   screenWidth: screenWidth,
//                                                   icon: Icons.check_rounded,
//                                                   iconColor: Colors.green,
//                                                   ans: 'SI',
//                                                 ),
//                                                 AnswerCard(
//                                                   screenHeight: screenHeight,
//                                                   screenWidth: screenWidth,
//                                                   icon: Icons.close_rounded,
//                                                   iconColor: Colors.red,
//                                                   ans: 'NO',
//                                                 ),
//                                               ],
//                                             )),
//                                           ),
//                                         ),