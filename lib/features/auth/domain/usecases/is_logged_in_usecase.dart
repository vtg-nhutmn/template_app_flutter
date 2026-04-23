import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isLoggedIn();
  }
}
