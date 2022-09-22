import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var currentUser = Rx<User?>(null);
  RxBool isLoggedin = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    isAlreadyLoggedin();

    super.onInit();
  }

  Future<bool> login() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredentials = await _firebaseAuth.signInWithCredential(credential);

      currentUser.value = userCredentials.user;

      print('${currentUser.value}');
    } catch (e) {
      print(e);
      Get.snackbar('Error', '${e.toString()}');
    }
    return currentUser.value != null;
  }

  isAlreadyLoggedin() async {
    isLoggedin.value = _firebaseAuth.currentUser != null;
  }

  Future<bool> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    currentUser.value = null;
    return currentUser.value == null;
  }
}
