import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _googleSignIn = GoogleSignIn(clientId: _clientId);
  var currentUser = Rx<GoogleSignInAccount?>(null);
  RxBool isLoggedIn = false.obs;
  static final _clientId = dotenv.env['AUTH_CLIENT_ID'] ?? 'add Proper Values';

  @override
  void onInit() {
    isAlreadyLoggedIn();

    super.onInit();
  }

  Future<bool> login() async {
    try {
      currentUser.value = await _googleSignIn.signIn();
      print('${currentUser.value}');
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}');
    }
    return currentUser.value != null;
  }

  Future<void> isAlreadyLoggedIn() async {
    final result = await _googleSignIn.signInSilently();
    isLoggedIn.value = result != null ? true : false;
  }

  Future<bool> logout() async {
    currentUser.value = await _googleSignIn.signOut();
    return currentUser.value == null;
  }
}
