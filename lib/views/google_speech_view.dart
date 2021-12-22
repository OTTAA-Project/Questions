import 'dart:developer';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/controllers/sttController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GoogleSpeechView extends StatelessWidget {
  GoogleSpeechView({Key? key}) : super(key: key);
  final cSpeech = Get.put(SttController());
  final cDialogflow = Get.put(DialogflowController());
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF202125),
              borderRadius: BorderRadius.circular(12.0)),
          width: 50.w,
          height: 80.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Container(
                child: Column(
                  children: [
                    Text(
                      'Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    AvatarGlow(
                      animate: cSpeech.recognizing.value,
                      glowColor: Colors.white,
                      endRadius: 30.sp,
                      duration: Duration(seconds: 2),
                      repeatPauseDuration: Duration(milliseconds: 100),
                      repeat: true,
                      child: Container(
                        height: 20.h,
                        width: 20.w,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              log('TApped ');
                              if (!cSpeech.recognizing.value) {
                                cSpeech.streamingRecognize();
                                showDialog(
                                    context: context,
                                    builder: (context) => GoogleSpeechView());
                              } else {
                                cSpeech.stopRecording();
                              }
                            },
                            child: Icon(
                              cSpeech.recognizing.value
                                  ? Icons.mic_rounded
                                  : Icons.mic_none_rounded,
                              size: 22.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        '${cSpeech.text.value == '' ? 'Didn\'t Catch That. Try Speaking Again' : '${cSpeech.text.value}'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )),
              Obx(
                () => Container(
                  width: 12.w,
                  child: MaterialButton(
                    color: kColorAppbar,
                    onPressed: () {
                      cSpeech.stopRecording();
                      cDialogflow.sendMessage(
                          cSpeech.text != '' ? cSpeech.text.value : '');
                      cSpeech.recognizeFinished.value ? Get.back() : null;
                    },
                    child: Text(cSpeech.recognizing.value ? 'Stop' : 'Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Text(
                'Spanish',
                style: TextStyle(color: Colors.white54),
              )
            ],
          ),
        ),
      ),
    );
  }
}
