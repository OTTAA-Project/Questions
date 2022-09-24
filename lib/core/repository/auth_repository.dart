import 'package:either_dart/either.dart';

abstract class AuthRepository<F, S> {
  Future<Either<F, S>> signIn();
  Future<Either<F, S>> getCurrentUser();
  Future<void> logout();
}
