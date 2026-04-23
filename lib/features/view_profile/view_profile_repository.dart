import 'package:dio/dio.dart';
import 'package:vsa_model/core/network/api_client.dart';
import 'profile_model.dart';

class ViewProfileRepository {
  final Dio _dio;

  ViewProfileRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance;

  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] as String? ?? 'Không tải được hồ sơ';
      throw Exception(message);
    }
  }
}
