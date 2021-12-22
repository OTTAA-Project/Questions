import 'dart:developer';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DialogflowController extends GetxController {
  final dref = FirebaseDatabase.instance.ref('Pictos/es');
  RxList dataList = [].obs;
  late DialogFlowtter dialogFlowtter;
  RxBool responseDone = false.obs;
  RxList firebaseIdentifiers = [].obs;
  RxList dataMapList = [].obs;
  @override
  void onInit() {
    super.onInit();
    log('called from DialogFlow');
    firebaseIdentifiers.value = [];
    initDF();
  }

  initDF() async {
    responseDone.value = false;
    dialogFlowtter = await DialogFlowtter(
      credentials: DialogAuthCredentials.fromJson({
        "type": "service_account",
        "project_id": "questions-abd23",
        "private_key_id": "75123030cf4561cf26cf434242fe9a0322c5a51b",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCkHgC1SC4/qHHA\nDIArAFuyb8rnE6BQ1bZ0nAv8MCH7mEm5wIvrRfLrodZguhnxWIfpFXNbjXp4sBOk\njuGu83D2USs/CYNFwO97jgoCZ2A1LJPJ+ZDk2b7hYHFisIw5aIZ54s4JQ+fybhqJ\n7SjJt0sAAPrvyWq+e2McuadnrUy1d3l61ATG1mTkFm6nhTi3/c6jREWXxCbFVEmx\ndw7WIdUKlBuAxX83/btj5QxZP4hX1rR9FDPU7t1PsfQ+1a2afTM1P4QoB9QvuNZC\nmndITamIHoibxE7XsccWmCyPtl+LD+paXSEhvyhxw3cVYgM+8MWc7i+6KNwJy27R\nyUw8tL5PAgMBAAECggEAOGAoDR3I6UwjGv4QTvU2CpMVZ5BZ2zq2jNMH2O7t1X/I\nH5tRVRX3rtKukhaLj9jCAyK/uDzey7NsY/RC+Tad4LccPHC3m8/9U/uEW7QIG+v+\nrnxgtgRIaiIXgPe1i4jo3Ni4vv0JIcGJs0R45OXmSQ+NI66UUO+Qqc7qfxZMSe89\n5Grmq+LwNmGVIhRbkCw+ilHsgXV7y/y3dOfqnHaZpyqB9sLHxLOnJ8RZdaFrEczN\nOBLZDlEj57L5X4qK/vDB/HnF8gRR4FIGQt3GtcmdlpUl4rUhCz+7crZGlX6RDop7\nU7Q3N98+dhjOdPIL02Q8Gj7vZp4tb6ho3YlWWv8pjQKBgQDcgi0+32hS0XZkw2Mp\nSDYcJM2/gOYMfox/uTFKIcEQ3AwJiJqo58v/faG9z71IxfVWeGpbPv7YFE8bC90J\n5dZcj9Wrvgm0otq6mEwHLxn5gIfTuoSJJZRiM4nmxnZL6tPEhC/hMDzU+VrkYqwl\nxTsxkKboJ4zkLErEECH0dXDUfQKBgQC+iEfyCIxP1sG59wnH1f0rStNZ2w3Hv5of\nLjKLc17iDqfOdDi0Tp7Gy1LpWqdxLORRZEHC93fms5EYaD3nEgUXdfgBrvaXQv/u\nee/9yT7WuAIvLQdCSGn5EyMubRPEZlS+6sgHEWr3HPewHPoHPOH2EIIYx02/v7vf\nTIUH3glTuwKBgBEVEJY/TmCkE2zo6gSnsHFrtHiybp/nKdE3ModQqBk7Qr92Uqzl\nEBuhyubecgZyN3hUacDZ13o70IkC2UPMB1gyWFYuqafRueocpD8mOffnKh6P43aQ\nb7dP0M4M79sfvPoLV341c3D4RD9PGZDvf49uak+vyK1gdQZNTaQXeP8tAoGAVj8W\nYicgbJuIAggjc0QYX9p1JX2VFVBUEb01wA4vayC7MSdG68eS8+Xh2CPjG8X4bCd3\n5StkKRgrm+LD8q8jguUxqIFsujfn5iloS3cnbMbKplQ5rvVckxTongFeK08vGWTp\nutlVlBqWvC/BtjkHB/2dBl5hgWTnREM9DLyjeDUCgYAqRZyd5oENABTrbLuxAqiA\n/7jjoM06qzt635dSjnEqNsuyKe6Lb/qhAGcJIRklD4EdTKPEjwqQK6sPa4uZ4t1z\nY/wQUA2VEYx1K/GSK/Op1L7qKjZa4RbGXJHOhBK7EHNA8pYAVA2N7m/zDUD2QnPR\nmbbr/+Ng7hUJP2AU/8NAJw==\n-----END PRIVATE KEY-----\n",
        "client_email": "questions-abd23@appspot.gserviceaccount.com",
        "client_id": "103934915366475103170",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/questions-abd23%40appspot.gserviceaccount.com"
      }),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) return;

    final message = text.split('\n').last;
    log('CHECKING +---=====+++ $message');
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput:
            QueryInput(text: TextInput(text: message, languageCode: 'es')));
    if (response.message == null) return;

    print('CHECKING RESPONSE _________ ++++ _____ +++ ${response.text}');
    firebaseIdentifiers.value =
        List.from(response.text!.trim().split(',').toList());

    responseDone.value = true;
    getData();
  }

  Future<void> getData() async {
    print('in getData ');
    firebaseIdentifiers.forEach((identifier) async {
      print('individaul identifier : $identifier');
    });

    print(
        'LENGTH OF THE LIST ++++++++++++++++++++++++ ${firebaseIdentifiers.length}');

    await dref.once().then((value) {
      for (int i = 0; i < firebaseIdentifiers.length; i++) {
        print('Printed $i');

        print(
            'KEY  - ${value.snapshot.child('${firebaseIdentifiers[i]}').key} + ${value.snapshot.child('${firebaseIdentifiers[i]}').child('picto').value.toString()}');
        dataMapList.add({
          'key': value.snapshot.child('${firebaseIdentifiers[i]}').key,
          'label': value.snapshot
              .child('${firebaseIdentifiers[i]}')
              .child('nombre')
              .value,
          'url': value.snapshot
              .child('${firebaseIdentifiers[i]}')
              .child('picto')
              .value,
        });
      }
    });
    print('Data List : ' + dataMapList.toString());
    responseDone.value = true;
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}
