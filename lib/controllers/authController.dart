import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _googleSignin = GoogleSignIn(clientId: _clientId);
  var currentUser = Rx<GoogleSignInAccount?>(null);

  static final _clientId =
      '122497661206-tq0bp15pm099pf95i554jaqqfg0pu8cb.apps.googleusercontent.com';
  Future<bool> login() async {
    currentUser.value = await _googleSignin.signIn();
    return currentUser.value != null;
  }

  Future<bool> logout() async {
    currentUser.value = await _googleSignin.signOut();
    return currentUser.value == null;
  }
}
