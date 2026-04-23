import 'package:dio/dio.dart';
import 'package:vsa_model/core/network/api_client.dart';
import 'login_model.dart';

class LoginRepository {
  final Dio _dio;
  LoginRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance;
  Future<String> login(LoginModel model) async {
    try {
      final response = await _dio.post(
        '/auth/signin',
        data: {'username': model.username, 'password': model.password},
      );
      return response.data['accessToken'] as String;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] as String? ?? 'Đăng nhập thất bại';
      throw Exception(message);
    }
  }
}
