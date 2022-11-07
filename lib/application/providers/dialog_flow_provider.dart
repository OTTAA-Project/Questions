import 'dart:math' as math;

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questions_by_ottaa/core/repository/language_repository.dart';
import 'package:quiver/iterables.dart';

class DialogFlowProvider extends ChangeNotifier implements LanguageRepository {
  final dref = FirebaseDatabase.instance.ref('Pictos/es'); //! Refactor wihtout

  late DialogFlowtter dialogFlowtter;

  List firebaseIdentifiers = [];

  List<Map<String, String>> dataMapList = [];
  List<List<Map<String, String>>> subDataMapList = [
    [
      {'label': '', 'url': ''},
      {'label': '', 'url': ''},
      {'label': '', 'url': ''},
      {'label': '', 'url': ''}
    ]
  ];

  final List<String> defaultFallback = [
    '¿Cómo dijiste?',
    '¿No te entendí, podés repetir?',
    'Por favor, formulá una pregunta del tipo SI / NO',
    '¿Puedes decirlo otra vez?',
  ];

  DialogFlowProvider() {
    init();
  }

  @override
  void dispose() {
    try {
      dialogFlowtter.dispose();
    } catch (_) {
      print('XDXXDXDDXDXD');
    }

    super.dispose();
  }

  @override
  Future<void> getAll() async {
    dataMapList.clear();
    subDataMapList.clear();

    subDataMapList = [
      [
        {'key': '', 'label': '', 'url': ''}
      ],
      [
        {'key': '', 'label': '', 'url': ''}
      ],
      [
        {'key': '', 'label': '', 'url': ''}
      ],
      [
        {'key': '', 'label': '', 'url': ''}
      ],
    ];

    print('LENGTH OF THE firebaseIdentifiers ++++++++++++++++++++++++ ${firebaseIdentifiers.length}');

    DatabaseEvent db = await dref.once();

    for (var identifier in firebaseIdentifiers) {
      if (db.snapshot.child(identifier).child('nombre').value != null) {
        dataMapList.add({
          'key': db.snapshot.child(identifier).key.toString(),
          'label': db.snapshot.child(identifier).child('nombre').value.toString(),
          'url': db.snapshot.child(identifier).child('picto').value.toString(),
        });
      } else {
        dataMapList = [
          {'label': '', 'url': ''},
          {'label': '', 'url': ''},
          {'label': '', 'url': ''},
          {'label': '', 'url': ''}
        ];
      }
    }

    subDataMapList = partition(dataMapList, 4).toList();

    if (subDataMapList[0][0]['key'] == 'NaN') {
      subDataMapList = [
        [
          {'key': '', 'label': '', 'url': ''}
        ],
        [
          {'key': '', 'label': '', 'url': ''}
        ],
        [
          {'key': '', 'label': '', 'url': ''}
        ],
        [
          {'key': '', 'label': '', 'url': ''}
        ],
      ];
    }
  }

  @override
  Future<void> init() async {
    final String projectId = dotenv.env['PROJECT_ID'] ?? 'add Proper Values';
    final String privateKeyId = dotenv.env['PRIVATE_KEY_ID'] ?? 'add Proper Values';
    final String privateKey = dotenv.env['DIALOUGE_PRIVATE_KEY'] ?? 'add Proper Values';
    final String clientEmail = dotenv.env['CLIENT_EMAIL'] ?? 'add Proper Values';
    final String clientId = dotenv.env['CLIENT_ID'] ?? 'add Proper Values';
    final String clientX509CertUrl = dotenv.env['CLIENT_X509_CERT_URL'] ?? 'add Proper Values';
    dialogFlowtter = DialogFlowtter(
      credentials: DialogAuthCredentials.fromJson({
        "type": "service_account",
        "project_id": projectId,
        "private_key_id": privateKeyId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "client_id": clientId,
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": clientX509CertUrl,
      }),
    );
  }

  @override
  Future<void> save(String text) async {
    firebaseIdentifiers.clear();
    if (text.isEmpty) return;

    final message = text.split('\n').last;
    DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: message, languageCode: 'es')));
    if (response.message == null) return;

    for (var str in response.text!.trim().split(',').toList()) {
      if (str.isEmpty) {
        continue;
      }
      firebaseIdentifiers.add(str);
    }
    await getAll();

    notifyListeners();
  }
}

final dialogFlowProvider = ChangeNotifierProvider<DialogFlowProvider>((ref) {
  return DialogFlowProvider();
});
