// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  final dref = FirebaseDatabase.instance.ref('Pictos/es');
  // final cDf = Get.put(DialogflowController());

  RxList dataList = [].obs;

  RxList requiredData = [].obs;
  @override
  void onInit() {
    // loadDatafromFirebase();
    super.onInit();
  }

  loadDatafromFirebase() {
    dref.once().then((value) {
      for (var dataSnapshot in value.snapshot.children) {
        print(dataSnapshot);
        dataList.add({
          'key': dataSnapshot.key.toString(),
          'label': dataSnapshot.child('picto').value.toString(),
          'url': dataSnapshot.child('nombre').value.toString(),
        });
      }
    }).then((value) => print(dataList.value.toString()));
  }

  void storeRequiredData(List key) {
    log('StoreRequ');
    Future.delayed(Duration(seconds: 1));
    for (int i = 0; i < key.length; i++) {
      for (int j = i; j < dataList.length; j++) {
        if (dataList[i]['key'] == key[i]) {
          log('Found at $i');
          requiredData.add({
            'key': dataList[i]['key'],
            'label': dataList[i]['label'],
            'url': dataList[i]['url'],
          });
        }
        ;
      }
    }
  }
}
