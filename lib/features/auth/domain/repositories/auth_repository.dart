import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}
