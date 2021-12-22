import 'dart:async';
import 'dart:developer';

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
  RxBool result = true.obs;

  RxBool recognizing = false.obs;
  RxBool recognizeFinished = false.obs;
  RxString text = ''.obs;
  RxString errorString = ''.obs;
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  @override
  void onInit() {
    super.onInit();
    _recorder.initialize();
  }

  Future<void> streamingRecognize() async {
    text.value = '';
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();
    recognizing.value = true;

    final serviceAccount = ServiceAccount.fromString(r'''{
      "type": "service_account",
      "project_id": "questions-abd23",
      "private_key_id": "ef3d227001118f45cdfe697c6e9362451d70a54d",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQCncVNDjJ/D3Dd+\n5t8FpU15+40x9ssj9mN3Y2Zhmu38sLcWwveiEEQebZMbc0NgVR3OdzS7E83u3a5W\nORNP1fRBLQOUGxRUAxH9RU76PPvpvgpE8rIq/uPgiWSWX4xLubrto0qUHRpo77PY\n2Fbl81AqDkI/zh/naDe5RT1i+sr6kjZNxa71cKNfxKhi3NwMAiJqVhdURBDM6hG1\nWrMdNhPsP591NfIkKBAE0JdGRR2k6eIVJ7y4Kpat80klcq+EBDGjj4w6mvsmSHie\nU8dAIfxVqIhNLroO6rfVBl+9WqhJE48QhN0vxCaXNb3eagXNdOObChv07gWQiRHT\nj/ga1b61AgMBAAECgf8gNm0OUb9qrrL+duvw6hw9m2dOdWwfPwdjsHvBy0x9kIGo\nn1mElByGvg3O+h28KqPRVJ2QX/7+NSeU7uYINeEHqOFHXO5MO0r6rprDCXhtP2I6\nYXZlTyQHzmbLhxY2e0S68u8mD3NFPNgcn4IYOvbxIE0eeUkp+6K8wdVNdXIXQjoG\nvrwIbJpg3qXfcy89Jpo1ZEEhUdNQrQKxwgwrXf0bF2A49j6WoeLSI2Of7OHtb4aA\n6Zy9UScDXhDrgCOK5798gypRTQuMiXtfB2FVSsLsL4yyHSPOzc1nHh04zmR5EV93\nyYpHXxbBtx/GiDCKIRU41WW5/25iNHV76amEdqECgYEAz7WxDH0dtYtPUun2WAkP\n9/gOlT/3XCetKUBNKtckEfsmYXivYV4CAsRKZlWME/wyDhv8zU7lWIpLay2UQf9A\n7cr/UZXSIMrE7pgiFZWp1J63yYGhwD7MGgdkXUAFj2OYG2MCjZ4MMV0UGNwaMZJw\nW7lOt+2DkO0wpUc+yZkvM6ECgYEAzl8MyAKLZmi99/KLQMGHIhS/QP3SyLyfRrII\nYF3nmh925pa1hNEvR/jtDxYSqkMA2DARpIy5dZnOcJ3bhfwWOLa5Bj+ZfEZLgBru\nHPELzjvDaFhYjRAWPypQDbg5NqIdY+XaomSyJfET+Dlg51nZAs6sec7If6aJUuAm\n1oD/cpUCgYA8Bjqa7FE4lICg6mG5QS0vMK0uLmUSaZjd8eoa9j9DPvvxcQnlrmAQ\nYp9JgXFQmTHx596fiiw28Qgoeex9QgGGdoJgFla6CT7t4GMBL9X7Tr636dFPmBYt\nc3Nqi0TQEizzxSIIwOKvJUHYiUq8hqAXsa5w8p9xs0m6iaM4aR894QKBgHKlazxR\n7Y9e8Ool3CaFXMUaMYWxfL/3yaREk1K12ExO3ocLgpveeh3JtCiFYqkjv/xZ9/Mq\nGn2yjHUTvTiZ6t5m5DMMcgAQLTFlxJJfdueDW/ND4S28mh9NKlv01BP9y8YLk4JT\n3oQlgaqMdcEQsPZWSosAzXHc2r0nuWvBDihhAoGAUajNM4hC/ShQeHzN5hWgAqql\noStkt/r5RHNOkO+sAa0NyfSjiGgWlVU/HrZ8gAuigrgAID3PkfeWGtwrERyZfytq\nOMkR6FeZbb3DbgMv2AtF9iadN4Y2FRpifmbhNr6Es9cj9Z1WVhkXvpmC4jeYJcvJ\nS06RcZQwM5yn5l52KUw=\n-----END PRIVATE KEY-----\n",
      "client_email": "questions-abd23@appspot.gserviceaccount.com",
      "client_id": "103934915366475103170",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/questions-abd23%40appspot.gserviceaccount.com"
    }
    ''');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream!);

    var responseText = '';

    responseStream.listen(
        (data) {
          final currentText = data.results
              .map((e) => e.alternatives.first.transcript)
              .join('\n');

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

          result.value = qd.isYesNo(text.value);
          if (result.value) {
            result.value = false;
            log('It is a YES NO Question');
          } else {
            cDialogflow.sendMessage(text.value);
            print('out from send message');
            cDialogflow.getData();
          }
        });
  }

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
