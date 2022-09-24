import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:google_speech/google_speech.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/services.dart/YesNoDetection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

class SttController extends GetxController {
  final RecorderStream _recorder = RecorderStream();
  final qd = QuestionDetection();
  final cDialogflow = Get.put(DialogflowController());

  RxBool recognizing = false.obs;
  RxBool recognizeFinished = false.obs;
  RxString text = ''.obs;
  RxString errorString = ''.obs;
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  final audioPlayer = AudioCache();

  // final webPlayer = AudioPlayer();
  // final web = AudioPlayer();
  @override
  void onInit() {
    super.onInit();
    _recorder.initialize();
  }

  RxBool result = true.obs;

  Future<void> streamingRecognize() async {
    cDialogflow.isButtonShowed.value = false;
    // if (kIsWeb) {

    //   print('WEB PLAYED ');
    // } else
    // AudioPlayer().play('assets/start.mp3');
    // AudioCache().play('start.mp3');

    text.value = '';
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();
    recognizing.value = true;
    
    final clientX59 = dotenv.env['APP_ID'] ?? 'add Proper Values';
    
    final ServiceAccount serviceAccount = ServiceAccount.fromString({
      "type": "service_account",
      "project_id": dotenv.env['PROJECT_ID'] ?? 'add Proper Values',
      "private_key_id": dotenv.env['PRIVATE_KEY_ID_2'] ?? 'add Proper Values',
      "private_key": dotenv.env['DIALOUGE_PRIVATE_KEY_2'] ?? 'add Proper Values',
      "client_email": dotenv.env['CLIENT_EMAIL'] ?? 'add Proper Values',
      "client_id": dotenv.env['CLIENT_ID'] ?? 'add Proper Values',
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": clientX59,
    }.toString());

    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(StreamingRecognitionConfig(config: config, interimResults: true), _audioStream!);

    var responseText = '';

    responseStream.listen(
        (data) {
          final currentText = data.results.map((e) => e.alternatives.first.transcript).join('\n');

          if (data.results.first.isFinal) {
            responseText += '\n' + currentText;

            text.value = responseText;
            recognizeFinished.value = true;
          } else {
            text.value = responseText + '\n' + currentText;
            recognizeFinished.value = true;
          }
        },
        cancelOnError: true,
        onError: (e) {
          errorString.value = e.toString();
        },
        onDone: () async {
          recognizing.value = false;
          final uri = await AudioCache().load('done.mp3');

          final player = AudioPlayer();
          await player.play(DeviceFileSource(uri.path));

          result.value = qd.isYesNo(text.value);
          if (result.value) {
            isYesNoDetect.value = true;
            log('It is a YES NO Question');
            stopRecording();
          } else {
            isYesNoDetect.value = false;
            cDialogflow.sendMessage(text.value);
            print('out from send message');
            cDialogflow.getData();
            stopRecording();
          }
        });
  }

  RxBool isYesNoDetect = false.obs;

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    recognizing.value = false;
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'es-AR',
      );
}
