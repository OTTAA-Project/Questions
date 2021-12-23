import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:questions_by_ottaa/bindings/allBindings.dart';
import 'package:questions_by_ottaa/views/main_view.dart';

class AuthController extends GetxController {
  final _googleSignin = GoogleSignIn(clientId: _clientId);
  var currentUser = Rx<GoogleSignInAccount?>(null);
  RxBool isLoggedin = false.obs;
  static final _clientId =
      '122497661206-tq0bp15pm099pf95i554jaqqfg0pu8cb.apps.googleusercontent.com';

  @override
  void onInit() {
    // isAlreadyLoggedin();
    super.onInit();
  }

  Future<bool> login() async {
    try {
      currentUser.value = await _googleSignin.signIn();
      print('${currentUser.value}');
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}');
    }
    return currentUser.value != null;
  }

  isAlreadyLoggedin() async {
    final result = await _googleSignin.signInSilently();
    isLoggedin.value = result != null ? true : false;
  }

  Future<bool> logout() async {
    currentUser.value = await _googleSignin.signOut();
    return currentUser.value == null;
  }
}
