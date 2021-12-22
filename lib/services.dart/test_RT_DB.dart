// ignore_for_file: must_be_immutable


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RTDB extends StatefulWidget {
  RTDB({Key? key}) : super(key: key);

  @override
  State<RTDB> createState() => _RTDBState();
}

class _RTDBState extends State<RTDB> {
  final dref = FirebaseDatabase.instance.ref('Pictos/es');

  @override
  void initState() {
    super.initState();
    showData();
  }

  var data;
  showData() async {
    dref.once().then((value) {
      for (var dataSnapshot in value.snapshot.children) {
        print(dataSnapshot.value);
      }
    });
  }

  Widget showImage(DataSnapshot snapshot, List<String> k) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        // width: 50/,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            snapshot.child('picto').value.toString().isURL
                ? Image.network(
                    '${Uri.parse('${snapshot.child('picto').value}')}',
                    height: 40,
                    width: 40,
                  )
                : Text(
                    'NO URL',
                    style: TextStyle(color: Colors.white),
                  ),
            Text(
              '${snapshot.child('nombre_en').value.toString().capitalizeFirst}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '${snapshot.key}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
    // if (snapshot.key == k[0] &&
    //     snapshot.child('picto').value.toString().isURL) {

    // } else
    // return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          child: FirebaseAnimatedList(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            query: dref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: showImage(snapshot, ['-LdOoFWBcLM7WKm4hjK4']),
                ),
              );
              // return Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     width: Get.width * 0.2,
              //     height: Get.height * 0.8,
              //     color: Colors.red,
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Row(
              //             children: [
              //               Text('ID : '),
              //               Text('${snapshot.child('id').value}'),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: [
              //               Text('nombre : '),
              //               Text('${snapshot.child('nombre').value}'),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: [
              //               Text('nombreEn : '),
              //               Text('${snapshot.child('nombre').value}'),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: [
              //               Text('picto : '),
              //               Text('${snapshot.child('picto').value}'),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: [
              //               Text('relacion : '),
              //               Text('${snapshot.child('relacion').value}',),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             children: [
              //               Text('tipo : '),
              //               Text('${snapshot.child('tipo').value}'),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
