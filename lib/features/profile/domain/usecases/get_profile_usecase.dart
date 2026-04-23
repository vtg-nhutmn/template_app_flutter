import 'package:architecture/core/errors/failures.dart';
import 'package:architecture/core/usecases/usecase.dart';
import 'package:architecture/features/profile/domain/entities/profile_entity.dart';
import 'package:architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileUseCase implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) {
    return _repository.getProfile();
  }
}
