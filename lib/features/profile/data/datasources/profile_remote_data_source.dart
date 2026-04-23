import 'package:demo/core/constants/api_constants.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/network/dio_client.dart';
import 'package:demo/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.me);
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ??
            e.message ??
            'Không thể tải thông tin người dùng',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
