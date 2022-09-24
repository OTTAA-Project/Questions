import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questions_by_ottaa/core/repository/database_repository.dart';

class DatabaseProvider extends ChangeNotifier implements DatabaseRepository<List> {
  final dref = FirebaseDatabase.instance.ref('Pictos/es');

  final List<Map<String, dynamic>> dataList = [];

  final List<Map<String, dynamic>> requiredData = [];

  @override
  Future<void> init() async {
    DatabaseEvent db = await dref.once();

    for (var dataSnapshot in db.snapshot.children) {
      print(dataSnapshot);
      dataList.add({
        'key': dataSnapshot.key.toString(),
        'label': dataSnapshot.child('picto').value.toString(),
        'url': dataSnapshot.child('nombre').value.toString(),
      });
    }
  }

  @override
  Future<void> save(List data) async {
    for (int i = 0; i < data.length; i++) {
      for (int j = i; j < dataList.length; j++) {
        if (dataList[i]['key'] == data[i]) {
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

final databaseProvider = ChangeNotifierProvider<DatabaseProvider>((ref) {
  return DatabaseProvider();
});
