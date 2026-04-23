import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/auth/domain/entities/user_entity.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
