import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/main_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  Future.delayed(Duration(milliseconds: 1000));
  await dotenv.load(fileName: "dotenv");
  Future.delayed(Duration(milliseconds: 1000));
  WidgetsFlutterBinding.ensureInitialized();
  print('here is the values 3');
  print(dotenv.env['API_KEY']);
  kIsWeb
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: dotenv.env['API_KEY'] ?? 'add Proper Values',
            authDomain: dotenv.env['AUTH_DOMAIN'] ?? 'add Proper Values',
            databaseURL: dotenv.env['DATA_BASE_URL'] ?? 'add Proper Values',
            projectId: dotenv.env['PROJECT_ID'] ?? 'add Proper Values',
            storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'add Proper Values',
            messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'add Proper Values',
            appId: dotenv.env['APP_ID'] ?? 'add Proper Values',
            measurementId: dotenv.env['MEASUREMENT_ID'] ?? 'add Proper Values',
          ),
        )
      : await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(
    const MyApp(),
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
