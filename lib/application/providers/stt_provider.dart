import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_speech/google_speech.dart';
import 'package:questions_by_ottaa/application/providers/dialog_flow_provider.dart';
import 'package:questions_by_ottaa/core/repository/language_repository.dart';
import 'package:questions_by_ottaa/core/repository/stt_repository.dart';
import 'package:questions_by_ottaa/core/services/questions_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:sound_stream/sound_stream.dart';

class STTProvider extends SttRepository {
  final RecorderStream _recorder = RecorderStream();

  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

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
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });
    text = '';
    await _recorder.start();
    isRecognizing = true;
    notifyListeners();

    final String serviceAccountString = (await rootBundle.loadString('assets/service_account.json')).replaceAllMapped(
      RegExp(r'("{(.*?)}")'),
      (match) {
        final String value = (match.group(0) ?? '').replaceAll(RegExp(r'"|{|}'), "");
        return '"${(dotenv.env[value] ?? 'add Proper Values').toString()}"';
      },
    );

    log(serviceAccountString);

    final ServiceAccount serviceAccount = ServiceAccount.fromString(serviceAccountString);

    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

    final responseStream = speechToText.streamingRecognize(
      StreamingRecognitionConfig(config: _getConfig(), singleUtterance: true, interimResults: true),
      _audioStream!,
    );

    var responseText = '';

    responseStream.listen(
      (data) {
        final currentText = data.results.map((e) => e.alternatives.first.transcript).join('\n');

        if (data.results.first.isFinal) {
          responseText += '\n$currentText';
          text = responseText;
          isRecognizing = false;
        } else {
          text = '$responseText\n$currentText';
          isRecognizing = false;
        }
        notifyListeners();
      },
      cancelOnError: true,
      onError: (e) {
        error = e.toString();
        notifyListeners();
      },
      onDone: () async {
        print("DONE");
        isRecognizing = false;
        notifyListeners();
        final uri = await AudioCache().load('done.mp3');

        final player = AudioPlayer();
        await player.play(DeviceFileSource(uri.path));
        isQuestion = questionsService.isYesNo(text);

        if (!isQuestion) {
          await languageRepository.save(text);
        }
        await stopRecording();
      },
    );
  }

  @override
  Future<void> stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    isRecognizing = false;
    notifyListeners();
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'es-AR',
        useEnhanced: true,
      );
}

final sttProvider = ChangeNotifierProvider<SttRepository>((ref) {
  final questionsService = GetIt.I<QuestionsService>();

  final languageRepository = ref.watch<DialogFlowProvider>(dialogFlowProvider);

  return STTProvider(
    questionsService: questionsService,
    languageRepository: languageRepository,
  );
});
