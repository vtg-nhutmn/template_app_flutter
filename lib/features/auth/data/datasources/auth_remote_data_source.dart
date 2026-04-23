import 'package:architecture/core/constants/api_constants.dart';
import 'package:architecture/core/errors/exceptions.dart';
import 'package:architecture/core/network/dio_client.dart';
import 'package:architecture/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.signin,
        data: {'username': username, 'password': password},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Đăng nhập thất bại',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
