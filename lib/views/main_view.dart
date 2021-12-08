// ignore_for_file: dead_code

import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/mainViewController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final mainController = Get.put(MainViewController());
  // late stt.SpeechToText _speech;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails dd) {
          mainController.left.value = dd.localPosition.dx;
          mainController.top.value = dd.localPosition.dy;
        },
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              color: kPrimaryBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // images to be displayed after fetching the question
                  Expanded(
                      flex: 5,
                      child: Container(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var screenHeight = constraints.maxHeight;
                            var screenWidth = constraints.maxWidth;

                            debugPrint(
                                'Max height: $screenHeight, max width: $screenWidth');
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: size.height * 0.1,
                                    child: Center(
                                      child: Text(
                                        'Queres Comer?',
                                        style: TextStyle(
                                            color: kPrimaryFont,
                                            fontSize: 26.0),
                                      ),
                                    ),
                                  ),
                                  // Main RED
                                  Container(
                                    constraints: BoxConstraints(
                                        minHeight: screenHeight * 0.8,
                                        minWidth: screenWidth),
                                    // color: kPrimaryBG,

                                    ///////////// ANSWER SECTION
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: screenHeight * 0.6,
                                          width: screenWidth * 0.28,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // image Container
                                              Container(
                                                height:
                                                    (screenHeight * 0.8) * 0.6,
                                                width:
                                                    (screenWidth * 0.28) * 0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      width: 4,
                                                      color: kBorderColor),
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (_, constraints) {
                                                    return Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                      size: constraints
                                                          .biggest.height,
                                                    );
                                                  },
                                                ),
                                              )
                                              // Answer TEXT Container
                                              ,
                                              Container(
                                                child: Text('SI'),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: screenHeight * 0.6,
                                          width: screenWidth * 0.28,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // image Container
                                              Container(
                                                height:
                                                    (screenHeight * 0.8) * 0.6,
                                                width:
                                                    (screenWidth * 0.28) * 0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      width: 4,
                                                      color: kBorderColor),
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (_, constraints) {
                                                    return Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                      size: constraints
                                                          .biggest.height,
                                                    );
                                                  },
                                                ),
                                              )
                                              // Answer TEXT Container
                                              ,
                                              Container(
                                                child: Text('NO'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minHeight: screenHeight * 0.1),
                                        color: Colors.green,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )),

                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Toca el botón verde para hacer una pregunta',
                        style: TextStyle(color: kPrimaryFont, fontSize: 18.0),
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
                        height: 80,
                        width: 130,
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
                        animate: mainController.isListening.value,
                        glowColor: Colors.white,
                        endRadius: 60.0,
                        duration: Duration(seconds: 2),
                        repeatPauseDuration: Duration(milliseconds: 100),
                        repeat: true,
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          child: FittedBox(
                            child: FloatingActionButton(
                              backgroundColor: Color(0xFF03DAC5),
                              onPressed: () {
                                log('TApped ');
                                 },
                              child: Icon(
                                mainController.isListening.value
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
    );
  }
}