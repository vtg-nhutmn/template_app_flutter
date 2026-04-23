import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demo/features/auth/domain/entities/user_entity.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._firebaseAuth,
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
      return right(userModel.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return right(unit);
    } catch (e) {
      return left(ServerFailure(message: 'Đăng xuất thất bại: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final user = _firebaseAuth.currentUser;
      return right(user != null);
    } catch (e) {
      return left(
        ServerFailure(message: 'Không thể kiểm tra trạng thái đăng nhập'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String username,
    required String email,
    required String password,
    required String displayName,
    required String phone,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      await _remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
        phone: phone,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
