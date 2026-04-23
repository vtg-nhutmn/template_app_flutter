import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.logout();
  }
}
