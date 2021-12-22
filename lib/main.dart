import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/services.dart/test_RT_DB.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDYckwyYFjys6DlADmLko462F47eaXBkX0",
        authDomain: "questions-abd23.firebaseapp.com",
        databaseURL: "https://questions-abd23-default-rtdb.firebaseio.com",
        projectId: "questions-abd23",
        storageBucket: "questions-abd23.appspot.com",
        messagingSenderId: "122497661206",
        appId: "1:122497661206:web:a8c8094bd59ca40ca1f837",
        measurementId: "G-RMQ677H96F"),
  );

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
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthView(),
      );
    });
  }
}

// ignore: must_be_immutable
class Testing extends StatelessWidget {
  Testing({Key? key}) : super(key: key);
  final dref = FirebaseDatabase.instance.ref('Pictos/es');
  List identifiers = [
    '-LdOoXpHFB2lk2_BsDYp',
    '-LdOoXqmwn3XeWPrciXC',
    '-LdOoXsaLIZOHBNJx0--',
    '-LdOoXuF5SV3sJ9y7xGM',
    '-LdOoY3KcYvhk1LNvFIa',
    '-LdOoY52nPKO0F8PSIE5',
    '-LdOoYG_aib1lwviCpOa',
    '-LdOoYEbCHY3NS0vPiUH',
    '-LdOoY9ajLC1brSE-L6b'
  ];
  List<Map> mappedData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Image.network(Uri.parse(
                  'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/zid_dolor_de_muela.webp?alt=media&token=fcd6e767-b9fe-4e82-996b-a557569ee559')
              .toString())),
    );
  }
}
