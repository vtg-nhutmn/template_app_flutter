import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:demo/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final profile = await _remoteDataSource.getProfile();
      return right(profile.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
