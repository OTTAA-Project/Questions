import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:questions_by_ottaa/core/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier implements AuthRepository<String, User> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void notify() {
    notifyListeners();
  }

  @override
  Future<Either<String, User>> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return Right(user);
    } else {
      return const Left('No user logged in');
    }
  }

  @override
  Future<Either<String, User>> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredentials = await _firebaseAuth.signInWithCredential(credential);
      if (userCredentials.user != null) {
        return Right(userCredentials.user!);
      } else {
        return const Left('No user logged in');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message!);
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});
