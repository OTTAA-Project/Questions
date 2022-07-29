import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/controllers/mainViewController.dart';
import 'package:questions_by_ottaa/controllers/ttsController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/auth_view.dart';
import 'package:questions_by_ottaa/views/settings/settings_controller.dart';
import 'package:questions_by_ottaa/views/settings/settings_page.dart';

class DrawerWidget extends GetView<MainViewController> {
  DrawerWidget({Key? key}) : super(key: key);
  final cAuth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double horizontalSize = MediaQuery.of(context).size.width;
    double verticalSize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalSize * 0.02),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: verticalSize * 0.01),
          width: horizontalSize * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(verticalSize * 0.03),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kColorAppbar,
                      borderRadius: BorderRadius.circular(verticalSize * 0.027),
                    ),
                    height: verticalSize * 0.15,
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/drawer_asset_image.png',
                            height: verticalSize * 0.05,
                          ),
                          Image.asset(
                            'assets/images/ottaa_logo_drawer.png',
                            height: verticalSize * 0.09,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: verticalSize * 0.01,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalSize * 0.01),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTileWidget(
                          icon: Icons.volume_up,
                          title: 'Mute',
                          onTap: () async {
                            // _ttsController.setVolume =
                            //     controller.muteOrNot.value ? 0.8 : 0.0;
                            // controller.muteOrNot.value =
                            //     !controller.muteOrNot.value;
                            // print(_ttsController.volume);
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    // thickness: 0.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalSize * 0.01),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTileWidget(
                          icon: Icons.info_outline,
                          title: 'About Questions',
                          onTap: () {},
                        ),
                        ListTileWidget(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            final v2 = Get.lazyPut(() => TTSController());
                            final v = Get.lazyPut(() => SettingsController());
                            Get.to(SettingsPage());
                          },
                        ),
                        ListTileWidget(
                          icon: Icons.info_outline,
                          title: 'Tutorial'.tr,
                          onTap: () async {},
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    // thickness: 0.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalSize * 0.01),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ListTileWidget(
                        //   icon: Icons.highlight_remove,
                        //   title: 'close_application'.tr,
                        //   onTap: () async {
                        //     exit(0);
                        //   },
                        // ),
                        ListTileWidget(
                          icon: Icons.exit_to_app,
                          title: 'Sign out',
                          onTap: () async {
                            cAuth.logout();
                            Get.offAll(() => AuthView());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  ListTileWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double verticalSize = MediaQuery.of(context).size.height;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: verticalSize * 0.035,
      ),
      title: Text(
        title,
      ),
    );
  }
}
