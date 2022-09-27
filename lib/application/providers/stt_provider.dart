import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_speech/google_speech.dart';
import 'package:questions_by_ottaa/application/providers/dialog_flow_provider.dart';
import 'package:questions_by_ottaa/core/repository/language_repository.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';
import 'package:questions_by_ottaa/core/services/questions_service.dart';
import 'package:sound_stream/sound_stream.dart';

class STTProvider extends ChangeNotifier implements SttRepository {
  final RecorderStream _recorder = RecorderStream();

  final QuestionsService questionsService;
  final LanguageRepository languageRepository;

  @override
  String text = '';

  @override
  String error = '';

  @override
  bool isRecognizing = false;
  @override
  bool isQuestion = false;

  STTProvider({
    required this.questionsService,
    required this.languageRepository,
  }) {
    _recorder.initialize();
  }

  @override
  Future<void> startRecording() async {
    text = '';
    await _recorder.start();
    isRecognizing = true;
    notifyListeners();

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

    final responseStream = speechToText.streamingRecognize(StreamingRecognitionConfig(config: _getConfig(), interimResults: true), _recorder.audioStream);

    String responseText = '';

    responseStream.listen(
      (data) {
        final currentText = data.results.map((e) => e.alternatives.first.transcript).join('\n');

        if (data.results.first.isFinal) {
          responseText += '\n$currentText';
          text = responseText;
        } else {
          text = '$responseText\n$currentText';
        }
        isRecognizing = false;
      },
      cancelOnError: true,
      onError: (e) {
        error = e.toString();
      },
      onDone: () async {
        isRecognizing = false;
        final uri = await AudioCache().load('done.mp3');

        final player = AudioPlayer();
        await player.play(DeviceFileSource(uri.path));
        isQuestion = questionsService.isYesNo(text);

        if (!isQuestion) {
          await languageRepository.save(text);
          await languageRepository.getAll();
        }
        await stopRecording();
      },
    );
  }

  @override
  Future<void> stopRecording() async {
    await _recorder.stop();
    isRecognizing = false;
    notifyListeners();
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'es-AR',
      );
}

final sttProvider = ChangeNotifierProvider<STTProvider>((ref) {
  final questionsService = GetIt.I<QuestionsService>();

  final languageRepository = ref.watch<DialogFlowProvider>(dialogFlowProvider);

  return STTProvider(
    questionsService: questionsService,
    languageRepository: languageRepository,
  );
});
