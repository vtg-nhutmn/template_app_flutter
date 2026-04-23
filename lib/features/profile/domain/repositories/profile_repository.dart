import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
}
