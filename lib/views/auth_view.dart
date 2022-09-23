import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/main_view.dart';

class AuthView extends StatelessWidget {
  AuthView({Key? key}) : super(key: key);
  final cAuth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryBG,
      body: SizedBox.fromSize(
        size: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ottaa_logo_drawer.png', width: (size.width / 3)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Bienvenido', style: textTheme.titleLarge!.copyWith(color: kPrimaryFont, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Regístrate con tu cuenta de Google para acceder a todas las funciones de la aplicación',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium!.copyWith(color: kPrimaryFont.withOpacity(.8), fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // GOOGLE BUTTON
                  GestureDetector(
                    onTap: () async {
                      if (cAuth.currentUser.value == null) {
                        try {
                          bool isDone = await cAuth.login();
                          isDone ? Get.off(() => MainView()) : null;
                        } catch (e) {
                          log('====ERROR OCCURED $e');
                        }
                      } else {
                        Get.snackbar(
                          '${cAuth.currentUser.value?.displayName}',
                          'You are already LoggedIn',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          mainButton: TextButton(
                            onPressed: () => Get.off(() => MainView()),
                            child: Text(
                              'Goto Main Screen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.asset('assets/images/gIcon.png'),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            flex: 4,
                            child: Text(
                              'Acceder con Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
