import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) {
    return _repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
      displayName: params.displayName,
      phone: params.phone,
    );
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String displayName;
  final String phone;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.displayName,
    required this.phone,
  });

  @override
  List<Object?> get props => [username, email, password, displayName, phone];
}
