import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/application/common/constants.dart';
import 'package:questions_by_ottaa/views/settings/language_page.dart';
import 'package:questions_by_ottaa/views/settings/voice_and_subtitle_page.dart';

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
            'Settings'.tr,
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
              children: [
                Text(
                  'SETTINGS'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.grey[700],
                ),
                ListTile(
                  leading: Icon(
                    Icons.record_voice_over,
                    color: kOTTAAOrangeNew,
                  ),
                  onTap: () {
                    Get.to(VoiceAndSubtitlesPage());
                  },
                  title: Text('Voice and Subtitles'.tr),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: kOTTAAOrangeNew,
                  ),
                  onTap: () {
                    Get.to(LanguagePage());
                  },
                  title: Text('Language'.tr),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
