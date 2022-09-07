import 'dart:developer';
import 'dart:math' as math;

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:quiver/iterables.dart';

class DialogflowController extends GetxController {
  final dref = FirebaseDatabase.instance.ref('Pictos/es');
  late DialogFlowtter dialogFlowtter;
  RxList firebaseIdentifiers = [].obs;
  RxList<Map<String, String>> dataMapList = RxList<Map<String, String>>();
  RxList<List<Map<String, String>>> subDataMapList = [
    [
      {'label': '', 'url': ''},
      {'label': '', 'url': ''},
      {'label': '', 'url': ''},
      {'label': '', 'url': ''}
    ]
  ].obs;
  final _random = new math.Random();

  final List<String> defaultFallback = [
    '¿Cómo dijiste?',
    '¿No te entendí, podés repetir?',
    'Por favor, formulá una pregunta del tipo SI / NO',
    '¿Puedes decirlo otra vez?'
  ];

  @override
  void onInit() {
    super.onInit();
    // log('called from DialogFlow');
    firebaseIdentifiers.value = [];
    // subDataMapList.value = [];
    initDF();
  }

  initDF() async {
    isButtonShowed.value = false;
    final String project_id = dotenv.env['PROJECT_ID'] ?? 'add Proper Values';
    final String private_key_id =
        dotenv.env['PRIVATE_KEY_ID'] ?? 'add Proper Values';
    final String private_key =
        dotenv.env['DIALOUGE_PRIVATE_KEY'] ?? 'add Proper Values';
    final String client_email =
        dotenv.env['CLIENT_EMAIL'] ?? 'add Proper Values';
    final String client_id = dotenv.env['CLIENT_ID'] ?? 'add Proper Values';
    final String client_x509_cert_url =
        dotenv.env['CLIENT_X509_CERT_URL'] ?? 'add Proper Values';
    dialogFlowtter = await DialogFlowtter(
      credentials: DialogAuthCredentials.fromJson({
        "type": "service_account",
        "project_id": project_id,
        "private_key_id": private_key_id,
        "private_key": private_key,
        "client_email": client_email,
        "client_id": client_id,
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": client_x509_cert_url,
      }),
    );
  }

  sendMessage(String text) async {
    firebaseIdentifiers.clear();
    if (text.isEmpty) return;

    final message = text.split('\n').last;
    // log('CHECKING +---=====+++ $message');
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput:
            QueryInput(text: TextInput(text: message, languageCode: 'es')));
    if (response.message == null) return;

    // print('CHECKING RESPONSE _________ ++++ _____ +++${response.text}');
    // firebaseIdentifiers.value =
    //     List.from(response.text!.trim().split(',').toList());

    for (var str in response.text!.trim().split(',').toList()) {
      if (str != "") {
        // log('NOT EMPTY');
        firebaseIdentifiers.add(str);
      } else {
        // log('EMPTY');
      }
    }
    print('BEFORE IDENTIFIERS : $firebaseIdentifiers');
    getData();
  }

  Future<void> getData() async {
    print('in getData ');
    dataMapList.clear();
    subDataMapList.clear();

    log('getData():dataMapList: ${dataMapList} ');
    log('getData(): subDataMapList: ${subDataMapList}');

    subDataMapList.value = [
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
    firebaseIdentifiers.forEach((identifier) async {
      print('individaul identifier : $identifier');
    });

    print(
        'LENGTH OF THE firebaseIdentifiers ++++++++++++++++++++++++ ${firebaseIdentifiers.length}');
    if (firebaseIdentifiers == 'NaN') {
      dataMapList.value = [
        {'label': '', 'url': ''},
        {'label': '', 'url': ''},
        {'label': '', 'url': ''},
        {'label': '', 'url': ''}
      ];
    } else
      await dref.once().then((value) {
        for (int i = 0; i < firebaseIdentifiers.length; i++) {
          print(
              '[[[[[[[ KEY  - ${value.snapshot.child('${firebaseIdentifiers[i]}').key}\n ${value.snapshot.child('${firebaseIdentifiers[i]}').child('picto').value.toString()} \n  ${value.snapshot.child('${firebaseIdentifiers[i]}').child('nombre').value.toString()}]]]]]]]');
          if (value.snapshot
                  .child('${firebaseIdentifiers[i]}')
                  .child('nombre')
                  .value !=
              null) {
            dataMapList.add({
              'key': value.snapshot
                  .child('${firebaseIdentifiers[i]}')
                  .key
                  .toString(),
              'label': value.snapshot
                  .child('${firebaseIdentifiers[i]}')
                  .child('nombre')
                  .value
                  .toString(),
              'url': value.snapshot
                  .child('${firebaseIdentifiers[i]}')
                  .child('picto')
                  .value
                  .toString(),
            });
          } else {
            dataMapList.value = [
              {'label': '', 'url': ''},
              {'label': '', 'url': ''},
              {'label': '', 'url': ''},
              {'label': '', 'url': ''}
            ];
            int index = _random.nextInt(defaultFallback.length);
            Get.snackbar('${defaultFallback[index]}', 'Try Again',
                backgroundColor: Colors.white);
            showWaiting.value = false;
          }
        }
      });
    final mySubList = partition(dataMapList, 4).toList();
    subDataMapList.value = List.from(mySubList);
    // log('${subDataMapList.length}');

    subDataMapList[0][0]['key'] == 'NaN'
        ? subDataMapList.value = [
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
          ]
        : null;
    isButtonShowed.value =
        subDataMapList.length > 0 && subDataMapList[1].length == 4;
    print('VALUE OF ISBUTTONSHOWED : ${isButtonShowed.value}');
    if (dataMapList[0]['label'] == null.toString()) {
      Get.snackbar('Try Again', 'No Data Found', backgroundColor: Colors.white);
      showWaiting.value = false;
    } else {
      responseDone.value = true;

      showWaiting.value = false;
    }
    print('DATA LASTLY : $subDataMapList');
    responseDone.value = false;
  }

  RxBool isButtonShowed = false.obs;

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}
