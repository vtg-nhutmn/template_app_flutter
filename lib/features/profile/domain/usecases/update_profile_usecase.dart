import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/profile/domain/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUseCase implements UseCase<Unit, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      displayName: params.displayName,
      phone: params.phone,
      email: params.email,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String displayName;
  final String phone;
  final String email;

  const UpdateProfileParams({
    required this.displayName,
    required this.phone,
    required this.email,
  });

  @override
  List<Object?> get props => [displayName, phone, email];
}
