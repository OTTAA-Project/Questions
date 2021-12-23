// ignore_for_file: dead_code, must_be_immutable

import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/databaseController.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/controllers/mainViewController.dart';
import 'package:questions_by_ottaa/controllers/sttController.dart';
import 'package:questions_by_ottaa/controllers/ttsController.dart';
import 'package:questions_by_ottaa/controllers/webAudioController.dart';
import 'package:questions_by_ottaa/services.dart/YesNoDetection.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/google_speech_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final mainController = Get.put(MainViewController());
  // final cAuth = Get.put(AuthController());
  final cQuestions = Get.put(QuestionDetection());
  final cSpeech = Get.find<SttController>();
  final cWebAudio = Get.put(WebAudioController());
  // final cDatabase = Get.put(DatabaseController());
  final cDialogflow = Get.put(DialogflowController());
  final cWebAudioController = Get.put(WebAudioController());

  bool isYesNo = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
          backgroundColor: kColorAppbar,
          automaticallyImplyLeading: false,
          // actions: [
          // ActionChip(
          //     // backgroundColor: kPrimaryFont,
          //     shape: RoundedRectangleBorder(),
          //     label: Text(
          //       'Logout',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     onPressed: () {
          //       cAuth.logout();
          //       Get.to(() => AuthView());
          //     }),
          // SizedBox(
          //   width: 20.0,
          // )
          // ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (DragUpdateDetails dd) {
            mainController.left.value = dd.localPosition.dx;
            mainController.top.value = dd.localPosition.dy;
          },
          child: Stack(
            children: [
              Container(
                height: 100.h,
                width: 100.w,
                color: kPrimaryBG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Container(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              var screenHeight = constraints.maxHeight;
                              var screenWidth = constraints.maxWidth;
                              return SingleChildScrollView(
                                  child: Obx(
                                () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        // height: size.height * 0.1,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              cSpeech.text == ''
                                                  ? '${cWebAudioController.lastWords.value}'
                                                  : '${cSpeech.text.value}',
                                              maxLines: 2,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kPrimaryFont,
                                                  fontSize: 16.0.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ////////////// RESULTS DISPLAY
                                      !cWebAudio.isYesNoBool.value ||
                                              cSpeech.isYesNoDetect.value
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                YesNoWidget(
                                                  ans: 'SI',
                                                  icon: Icons.check_rounded,
                                                  iconColor: Colors.green,
                                                  screenWidth: screenWidth,
                                                  screenHeight: screenHeight,
                                                ),
                                                YesNoWidget(
                                                  ans: 'NO',
                                                  icon: Icons.close_rounded,
                                                  iconColor: Colors.red,
                                                  screenWidth: screenWidth,
                                                  screenHeight: screenHeight,
                                                )
                                              ],
                                            )
                                          : Container(
                                              height: 60.h,
                                              width: double.infinity,
                                              child: ListView.builder(
                                                  itemCount: cDialogflow
                                                      .dataMapList.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return cDialogflow.dataMapList[
                                                                        index]
                                                                    ['label'] ==
                                                                null ||
                                                            cDialogflow.dataMapList[
                                                                        index]
                                                                    ['label'] ==
                                                                null
                                                        ? SizedBox()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: AnswerCard(
                                                              ans: cDialogflow
                                                                      .dataMapList[
                                                                  index]['label'],
                                                              icon: cDialogflow
                                                                      .dataMapList[
                                                                  index]['url'],
                                                              iconColor:
                                                                  Colors.blue,
                                                              screenWidth:
                                                                  screenWidth,
                                                              screenHeight:
                                                                  screenHeight,
                                                            ),
                                                          );
                                                  }),
                                            )
                                    ]),
                              ));
                            },
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Toca el botón verde para hacer una pregunta',
                          style:
                              TextStyle(color: kPrimaryFont, fontSize: 17.0.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Positioned(
                  top: mainController.top.value,
                  left: mainController.left.value,
                  child: Stack(
                    children: [
                      LayoutBuilder(builder: (_, constraints) {
                        return Container(
                          height: 80, // 80
                          width: 130, // 130
                          decoration: BoxDecoration(
                            color: Color(0xFFBB86FC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60.0),
                              bottomLeft: Radius.circular(60.0),
                              topRight: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.menu,
                                size: 40,
                              ),
                            ),
                          ),
                        );
                      }),
                      Positioned(
                        left: 35,
                        top: -20,
                        child: AvatarGlow(
                          animate: cSpeech.recognizing.value,
                          glowColor: Colors.white,
                          endRadius: 60.0,
                          duration: Duration(seconds: 2),
                          repeatPauseDuration: Duration(milliseconds: 100),
                          repeat: true,
                          child: Container(
                            height: 60.0,
                            width: 60.0,
                            child: FittedBox(
                              child: kIsWeb
                                  ? FloatingActionButton(
                                      backgroundColor: Color(0xFF03DAC5),
                                      onPressed: () {
                                        log('TApped WINDOWS ');
                                        if (cWebAudioController
                                            .isListening.value) {
                                          cWebAudioController.stopListening();
                                        } else {
                                          cWebAudioController.startListening();
                                          // cWebAudio.isYesNoBool.value = true;
                                          cDialogflow.dataMapList.value = [];
                                        }
                                      },
                                      child: Icon(
                                        cWebAudioController.isListening.value
                                            ? Icons.mic_rounded
                                            : Icons.mic_none_rounded,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    )
                                  : FloatingActionButton(
                                      backgroundColor: Color(0xFF03DAC5),
                                      onPressed: () {
                                        log('TApped ');

                                        if (!cSpeech.recognizing.value) {
                                          cSpeech.streamingRecognize();
                                          isYesNo = cQuestions
                                              .isYesNo(cSpeech.text.value);
                                          isYesNo == true
                                              ? null
                                              : cDialogflow.sendMessage(
                                                  cSpeech.text.value);
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  GoogleSpeechView());
                                        } else {
                                          cSpeech.stopRecording();
                                        }
                                      },
                                      child: Icon(
                                        cSpeech.recognizing.value
                                            ? Icons.mic_rounded
                                            : Icons.mic_none_rounded,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YesNoWidget extends StatelessWidget {
  YesNoWidget({
    Key? key,
    this.screenHeight,
    this.screenWidth,
    this.icon,
    this.iconColor,
    this.ans,
  }) : super(key: key);

  double? screenHeight = Get.height;
  double? screenWidth = Get.width;
  IconData? icon;
  Color? iconColor;
  String? ans;

  final cTTS = Get.put(TTSController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('Tapped == Will speak the Answer when clicked using TTS');
        cTTS.speak(ans!.toLowerCase());
      },
      child: Container(
        height: screenHeight! * 0.6,
        width: screenWidth! * 0.28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // image Container
            Container(
              height: (screenHeight! * 0.8) * 0.6,
              width: (screenWidth! * 0.28) * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 4, color: kBorderColor),
              ),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Icon(
                    icon,
                    color: iconColor,
                    size: constraints.biggest.height,
                  );
                },
              ),
            ),
            Container(
              child: Text(
                ans!.toUpperCase(),
                style: TextStyle(fontSize: 15.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  AnswerCard({
    Key? key,
    this.screenHeight,
    this.screenWidth,
    this.icon,
    this.iconColor,
    this.ans,
  }) : super(key: key);

  double? screenHeight = Get.height;
  double? screenWidth = Get.width;
  String? icon;
  Color? iconColor;
  String? ans;

  final cTTS = Get.put(TTSController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('Tapped == Will speak the Answer when clicked using TTS');
        cTTS.speak(ans!.toLowerCase());
      },
      child: Container(
        height: screenHeight! * 0.6,
        width: screenWidth! * 0.28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // image Container
            Container(
              height: (screenHeight! * 0.8) * 0.6,
              width: (screenWidth! * 0.28) * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 4, color: kBorderColor),
              ),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Image.network(
                    '${Uri.parse('${icon}')}',
                    height: 40.h,
                    width: 30.w,
                  );
                },
              ),
            ),
            Container(
              child: Text(
                ans!.toUpperCase(),
                style: TextStyle(fontSize: 15.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
