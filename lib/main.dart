import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/main_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyDYckwyYFjys6DlADmLko462F47eaXBkX0",
              authDomain: "questions-abd23.firebaseapp.com",
              databaseURL:
                  "https://questions-abd23-default-rtdb.firebaseio.com",
              projectId: "questions-abd23",
              storageBucket: "questions-abd23.appspot.com",
              messagingSenderId: "122497661206",
              appId: "1:122497661206:web:a8c8094bd59ca40ca1f837",
              measurementId: "G-RMQ677H96F"),
        )
      : await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .whenComplete(
    () => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    log('MY APP INITSTATE ');
    auth.isAlreadyLoggedin();
    log('${auth.isLoggedin.value}');
    super.initState();
  }

  final auth = Get.put(AuthController());
  Widget homeWidget = AuthView();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: auth.isLoggedin.value ? MainView() : AuthView(),
      );
    });
  }
}
