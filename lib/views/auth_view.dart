import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questions_by_ottaa/bindings/allBindings.dart';
import 'package:questions_by_ottaa/controllers/authController.dart';
import 'package:questions_by_ottaa/utils/constants.dart';
import 'package:questions_by_ottaa/views/main_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthView extends StatelessWidget {
  AuthView({Key? key}) : super(key: key);
  final cAuth = Get.put(AuthController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: kColorAppbar,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: kPrimaryBG,
            child: Center(
                child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: constraints.maxHeight * 0.7,
                  width: constraints.maxWidth * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Bienvenido',
                                style: TextStyle(
                                    color: Color(0xFF777777), fontSize: 25.sp),
                              ),
                              SizedBox(
                                height: 15.sp,
                              ),
                              Text(
                                'Registrate con tu cuenta de Google para acceder a todas las funciones de la aplicacion',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF989898), fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),

                        // GOOGLE BUTTON
                        GestureDetector(
                          onTap: () async {
                            log('Google Button Tapped');
                            if (cAuth.currentUser.value == null) {
                              try {
                                bool isDone = await cAuth.login();
                                isDone
                                    ? Get.off(() => MainView())
                                    : null;
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
                            height: 27.sp,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          ('images/gIcon.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Acceder con Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
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
                ),
                Positioned(
                  top: -40,
                  child: Container(
                    child: CircleAvatar(
                      radius: 25.sp,
                      backgroundImage: AssetImage('images/logoOttaa.jpg'),
                    ),
                  ),
                )
              ],
            )),
          );
        },
      ),
    );
  }
}
