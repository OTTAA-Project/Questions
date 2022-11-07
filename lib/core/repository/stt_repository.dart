abstract class SttRepository {
  bool get isRecognizing;
  bool get isQuestion;

  String get text;
  String get error;

  Future<void> startRecording();
  Future<void> stopRecording();
}
