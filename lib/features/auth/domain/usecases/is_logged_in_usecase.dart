import 'package:architecture/core/errors/failures.dart';
import 'package:architecture/core/usecases/usecase.dart';
import 'package:architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isLoggedIn();
  }
}
