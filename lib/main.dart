import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/controllers/ttsController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/main_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quiver/iterables.dart';

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
    auth.isAlreadyLoggedin();
    // listSlicer(myList);
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
        // home: Testing(),
      );
    });
  }
}

class Testing extends StatelessWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey,
          height: 60.h,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(listSlicer(myList));
                      },
                      child: Text('PUSH'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(subList[initialIndex.value + 1].length);
                        subList[initialIndex.value + 1].length == 4
                            ? initialIndex.value++
                            : initialIndex.value = 0;
                        print('InitialINdex : ${initialIndex.value}');
                      },
                      child: Text('show next four'),
                    ),
                  ],
                ),
                Obx(() => Row(
                      children: [
                        OptionsWidget(
                          answer:
                              '${subList[initialIndex.value][0] == null ? subList[0][0] : subList[initialIndex.value][0]}',
                        ),
                        OptionsWidget(
                          answer:
                              '${subList[initialIndex.value][1] == null ? subList[0][1] : subList[initialIndex.value][1]}',
                        ),
                        OptionsWidget(
                          answer:
                              '${subList[initialIndex.value][2] == null ? subList[0][2] : subList[initialIndex.value][2]}',
                        ),
                        OptionsWidget(
                          answer:
                              '${subList[initialIndex.value][3] == null ? subList[0][3] : subList[initialIndex.value][3]}',
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List myList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
RxInt initialIndex = 0.obs;
RxList subList = [].obs;

listSlicer(List l) {
  print('Original : ${l.length}');
  final mySubList = partition(l, 4).toList();
  print('Sublist : ${mySubList.length}');
  subList.value = List.from(mySubList);
}

List<Map> dataMapList = [
  {
    'label': 'cantar',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_cantar.webp?alt=media&token=75f9c996-49d7-4976-aa0a-6b9d3d1e7d16'
  },
  {
    'label': 'dibujar',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_dibujar.webp?alt=media&token=aa97d928-dd55-4081-8d0c-989470f5e283'
  },
  {
    'label': 'escuchar música',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_escuchar_musica.webp?alt=media&token=bcd772fd-f4f1-4379-a577-3f3691e0c245'
  },
  {
    'label': 'hacer pis',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_hacerpis.webp?alt=media&token=3669ae18-849c-4817-b8e4-5c905f5af4b8'
  },
  {
    'label': 'leer',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/leer.webp?alt=media&token=785020a0-a116-42fc-aae6-6d5baff74988'
  },
  {
    'label': 'pasear',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_pasear.webp?alt=media&token=9dd9ff88-80af-42d5-8715-8f93b1a103a2'
  },
  {
    'label': 'mirar',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/mirar.webp?alt=media&token=ea144dcb-8eaf-4da3-a1bb-be53407a59e8'
  },
  {
    'label': 'reir',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/reir.webp?alt=media&token=8919386b-fe8a-4ad0-a59c-a6b20c5c1162'
  },
  {
    'label': 'sentarme',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/sentar.webp?alt=media&token=5e8439c7-7826-4b9b-8d39-9fe8947f6a79'
  },
  {
    'label': 'comer',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/comer.webp?alt=media&token=f97fbbf5-39a8-4436-86b5-b653f8e68097'
  },
  {
    'label': 'Cansado',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/ic_cansado.webp?alt=media&token=1deb33bb-8f23-4ad4-9c94-dfd2582e7950'
  },
  {
    'label': 'caliente',
    'url':
        'https://firebasestorage.googleapis.com/v0/b/respondedor-d9af9.appspot.com/o/caliente_cosa.webp?alt=media&token=42b97007-d524-4091-9c8d-6bc010f23dbf'
  }
];

class OptionsWidget extends StatelessWidget {
  OptionsWidget({
    this.answer,
    Key? key,
  }) : super(key: key);
  String? answer;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: (Get.size.height * 0.8) * 0.53,
                  width: (Get.size.width * 0.28) * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      width: 3,
                      color: Colors.pink,
                    ),
                  ),
                  child: Image.asset(
                    'images/yes.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '$answer'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
