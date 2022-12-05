import 'package:flutter/widgets.dart';

abstract class SttRepository extends ChangeNotifier {
  bool get isRecognizing;
  bool get isQuestion;

  String get text;
  String get error;

  Future<void> startRecording();
  Future<void> stopRecording();
}
