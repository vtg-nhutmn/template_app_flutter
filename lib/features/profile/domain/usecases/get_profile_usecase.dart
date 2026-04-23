import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:demo/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileUseCase implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) {
    return _repository.getProfile();
  }
}
