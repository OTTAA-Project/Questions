import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:questions_by_ottaa/application/application.dart';
import 'package:questions_by_ottaa/application/injector.dart';
import 'package:questions_by_ottaa/application/services/service_locator.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: "dotenv");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  await setupServices();

  runApp(
    const Injector(app: Application()),
  );
}
