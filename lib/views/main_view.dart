// ignore_for_file: dead_code, must_be_immutable

import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picto_widget/picto_widget.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/controllers/dialogflowController.dart';
import 'package:questions_by_ottaa/controllers/mainViewController.dart';
import 'package:questions_by_ottaa/controllers/sttController.dart';
import 'package:questions_by_ottaa/controllers/ttsController.dart';
import 'package:questions_by_ottaa/controllers/webAudioController.dart';
import 'package:questions_by_ottaa/services.dart/YesNoDetection.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/widgets/drawer_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final mainController = Get.put(MainViewController());
  final cAuth = Get.put(AuthController());
  final cQuestions = Get.put(QuestionDetection());
  final cSpeech = Get.put(SttController());
  final cWebAudio = Get.put(WebAudioController());
  final cDialogflow = Get.put(DialogflowController());
  final cWebAudioController = Get.put(WebAudioController());
  final TTSController ttsController = Get.put(TTSController());
  RxInt initIndex = 0.obs;
  bool isYesNo = false;

  @override
  Widget build(BuildContext context) {
    final verticalSize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
          backgroundColor: kColorAppbar,
          automaticallyImplyLeading: false,
        ),
        drawer: DrawerWidget(),
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
                                () => Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              cSpeech.text == '' ? '${ttsController.isCustomSubtitle ? cWebAudioController.lastWords.value.toUpperCase() : cWebAudioController.lastWords.value.toLowerCase()}' : '${ttsController.isCustomSubtitle ? cSpeech.text.value.toUpperCase() : cSpeech.text.value.toLowerCase()}',
                                              maxLines: 2,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryFont, fontSize: 16.0.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                      !cWebAudio.isYesNoBool.value || cSpeech.isYesNoDetect.value
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  YesNoWidget(
                                                    ans: 'SI',
                                                    icon: 'yes',
                                                    iconColor: Colors.green,
                                                    screenWidth: screenWidth,
                                                    screenHeight: screenHeight,
                                                  ),
                                                  YesNoWidget(
                                                    ans: 'NO',
                                                    icon: 'no',
                                                    iconColor: Colors.red,
                                                    screenWidth: screenWidth,
                                                    screenHeight: screenHeight,
                                                  )
                                                ],
                                              ),
                                            )
                                          : responseDone.value == true && showWaiting.value
                                              ? Container(
                                                  height: 55.h,
                                                  width: 98.w,
                                                  child: Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                )
                                              // : Text('show four widgets')
                                              : Container(
                                                  height: 55.h,
                                                  width: 98.w,
                                                  child: cDialogflow.subDataMapList[initIndex.value][0]['label'] == ''
                                                      ? SizedBox()
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            AnswerCard(
                                                              ans: cDialogflow.subDataMapList[initIndex.value][0]['label'],
                                                              icon: cDialogflow.subDataMapList[initIndex.value][0]['url'],
                                                              iconColor: Colors.blue,
                                                              screenWidth: Get.size.width * 0.81,
                                                              screenHeight: screenHeight,
                                                            ),
                                                            AnswerCard(
                                                              ans: cDialogflow.subDataMapList[initIndex.value][1]['label'],
                                                              icon: cDialogflow.subDataMapList[initIndex.value][1]['url'],
                                                              iconColor: Colors.blue,
                                                              screenWidth: Get.size.width * 0.81,
                                                              screenHeight: screenHeight,
                                                            ),
                                                            AnswerCard(
                                                              ans: cDialogflow.subDataMapList[initIndex.value][2]['label'],
                                                              icon: cDialogflow.subDataMapList[initIndex.value][2]['url'],
                                                              iconColor: Colors.blue,
                                                              screenWidth: Get.size.width * 0.81,
                                                              screenHeight: screenHeight,
                                                            ),
                                                            AnswerCard(
                                                              ans: cDialogflow.subDataMapList[initIndex.value][3]['label'],
                                                              icon: cDialogflow.subDataMapList[initIndex.value][3]['url'],
                                                              iconColor: Colors.blue,
                                                              screenWidth: Get.size.width * 0.81,
                                                              screenHeight: screenHeight,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Toca el micrófono y haz una pregunta',
                          style: TextStyle(color: kPrimaryFont, fontSize: 17.0.sp),
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
                          width: cDialogflow.isButtonShowed.value ? 200 : 130, // 130
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
                                      onPressed: () async {
                                        log('TApped WINDOWS ');
                                        if (cWebAudioController.isListening.value) {
                                          // does nothing
                                        } else {
                                          cWebAudioController.startListening();
                                          final uri = await AudioCache().load('start.mp3');

                                          final player = AudioPlayer();
                                          await player.play(DeviceFileSource(uri.path));

                                          initIndex.value = 0;
                                          cDialogflow.subDataMapList.clear();

                                          cDialogflow.subDataMapList.value = [
                                            [
                                              {'label': '', 'url': ''}
                                            ],
                                            [
                                              {'label': '', 'url': ''}
                                            ],
                                            [
                                              {'label': '', 'url': ''}
                                            ],
                                            [
                                              {'label': '', 'url': ''}
                                            ]
                                          ];
                                        }
                                      },
                                      child: Icon(
                                        cWebAudioController.isListening.value ? Icons.mic_rounded : Icons.mic_none_rounded,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    )
                                  : FloatingActionButton(
                                      backgroundColor: Color(0xFF03DAC5),
                                      onPressed: () async {
                                        log('TApped ');

                                        if (!cSpeech.recognizing.value) {
                                          // cDialogflow.subDataMapList.value = [
                                          //   [{}]
                                          // ];
                                          initIndex.value = 0;
                                          cSpeech.streamingRecognize();
                                          final uri = await AudioCache().load('start.mp3');

                                          final player = AudioPlayer();
                                          await player.play(DeviceFileSource(uri.path));
                                          // isYesNo = cQuestions
                                          //     .isYesNo(cSpeech.text.value);
                                          // isYesNo == true
                                          //     ? null
                                          //     : cDialogflow.sendMessage(
                                          //         cSpeech.text.value);
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (context) =>
                                          //         GoogleSpeechView());
                                        } else {
                                          cSpeech.stopRecording();
                                        }
                                      },
                                      child: Icon(
                                        cSpeech.recognizing.value ? Icons.mic_rounded : Icons.mic_none_rounded,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      if (cDialogflow.isButtonShowed.value)
                        Positioned(
                          left: 100,
                          top: 10,
                          child: Container(
                            height: 60.0,
                            width: 120.0,
                            child: FittedBox(
                              child: FloatingActionButton(
                                backgroundColor: kOTTAAOrangeNew,
                                onPressed: () {
                                  log('Pressed More Button');
                                  // log('Next Length : ${cDialogflow.subDataMapList[initIndex.value + 1].length} + DATA : ${cDialogflow.subDataMapList[initIndex.value + 1]}');
                                  // log('Current Length : ${cDialogflow.subDataMapList[initIndex.value].length} + DATA : ${cDialogflow.subDataMapList[initIndex.value]}');
                                  log('Current Index : ${initIndex.value}');

                                  if (initIndex.value + 1 == cDialogflow.subDataMapList.length) {
                                    log('IF FIRST CALLED');
                                    initIndex.value = 0;
                                  } else if (cDialogflow.subDataMapList[initIndex.value + 1].length == 4) {
                                    log('IF SELECTED');
                                    initIndex.value++;
                                  } else {
                                    log('ELSE SELECTED');
                                    initIndex.value = 0;
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 16,
                child: Row(
                  children: [
                    const Text(
                      'Powered by',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      'assets/images/ottaa_logo_drawer.png',
                      height: verticalSize * 0.05,
                    ),
                  ],
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
                  return Image.asset('images/$icon.png');
                },
              ),
            ),
            Container(
              child: Text(
                cTTS.isCustomSubtitle ? ans!.toUpperCase() : ans!.toLowerCase(),
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
    return PictoWidget(
      text: cTTS.isCustomSubtitle ? ans!.toUpperCase() : ans!.toLowerCase(),
      onTap: () {
        log('Tapped == Will speak the Answer when clicked using TTS');
        cTTS.speak(ans!.toLowerCase());
      },
      height: screenHeight! * 0.6,
      width: screenWidth! * 0.28,
      imageUrl: icon!,
    );
  }
}
