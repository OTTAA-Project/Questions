// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:get/get_connect/http/src/utils/utils.dart';

enum TTSState { playing, stopped, paused, continued }

class TTSController extends GetxController {
  final tts = FlutterTts();
  String _language =
      Get.locale?.languageCode == null ? 'es-AR' : Get.locale!.languageCode;
  late List<dynamic> availableTTS;

  String get languaje => this._language;

  set languaje(value) {
    this._language = value;
  }

  bool _isEnglish = true;

  bool get isEnglish => this._isEnglish;

  set isEnglish(value) {
    this._isEnglish = value;
  }

  bool _isCustomTTSEnable = false;

  bool get isCustomTTSEnable => this._isCustomTTSEnable;

  set isCustomTTSEnable(value) {
    this._isCustomTTSEnable = value;
  }

  bool _isCustomSubtitle = false;

  bool get isCustomSubtitle => this._isCustomSubtitle;

  set isCustomSubtitle(value) {
    this._isCustomSubtitle = value;
  }

  bool _isSubtitleUppercase = false;

  bool get isSubtitleUppercase => this._isSubtitleUppercase;

  set isSubtitleUppercase(value) {
    this._isSubtitleUppercase = value;
  }

  // ignore: unused_field
  String? _engine;

  double _volume = 0.8;

  double get volume => this._volume;

  int _subtitleSize = 2;

  int get subtitleSize => this._subtitleSize;

  set setVolume(value) {
    this._volume = value;
  }

  set subtitleSize(value) {
    this._subtitleSize = value;
  }

  double _pitch = 1.0;

  double get pitch => this._pitch;

  set pitch(value) {
    this._pitch = value;
  }

  double _rate = 0.4;

  double get rate => this._rate;

  set rate(value) {
    this._rate = value;
  }

  // bool isCurrentLanguageInstalled = false;

  TTSState _ttsState = TTSState.stopped;

  get isPlaying => this._ttsState == TTSState.playing;

  get isStopped => this._ttsState == TTSState.stopped;

  get isPaused => this._ttsState == TTSState.paused;

  get isContinued => this._ttsState == TTSState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  @override
  void onInit() async {
    configureTTS();
    availableTTS = await tts.getLanguages;
    super.onInit();
  }

  configureTTS() async {
    // print('configuring === TTS');
    await tts.setPitch(1);
    await tts.setLanguage('es-AR');
    await tts.awaitSpeakCompletion(true);
  }

  Future speak(String readAloud) async {
    if (readAloud.isNotEmpty) {
      await this.tts.setVolume(this._volume);
      // TODO CREATE DEFAULT VALUES
      if (this.isCustomTTSEnable) {
        await this.tts.setSpeechRate(this._rate);
        await this.tts.setPitch(this._pitch);
      } else {
        await this.tts.setSpeechRate(0.4);
        await this.tts.setPitch(1.0);
      }
      await this.tts.awaitSpeakCompletion(true);
      await this.tts.setLanguage(this._language);
      await this.tts.speak(readAloud);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
