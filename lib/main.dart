import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:questions_by_ottaa/application/application.dart';
import 'package:questions_by_ottaa/application/injector.dart';
import 'package:questions_by_ottaa/application/services/service_locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: "dotenv");

  WidgetsFlutterBinding.ensureInitialized();

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

  await setupServices();

  runApp(
    const Injector(app: Application()),
  );
}
