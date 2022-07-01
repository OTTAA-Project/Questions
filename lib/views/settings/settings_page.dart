import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final verticalSize = MediaQuery.of(context).size.height;
    return GetBuilder<SettingsController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'settings'.tr,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          // leading: Placeholder(),
          centerTitle: false,
          backgroundColor: Colors.grey[350],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
