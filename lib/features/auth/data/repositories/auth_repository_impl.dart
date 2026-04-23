import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:demo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demo/features/auth/domain/entities/user_entity.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final userModel = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      await _localDataSource.saveToken(userModel.accessToken);
      return right(userModel.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _localDataSource.deleteToken();
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _localDataSource.getToken();
      return right(token != null && token.isNotEmpty);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }
}
