import 'package:architecture/core/constants/api_constants.dart';
import 'package:architecture/core/errors/exceptions.dart';
import 'package:architecture/core/storage/secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(ApiConstants.tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Không thể lưu token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(ApiConstants.tokenKey);
    } catch (e) {
      throw CacheException(message: 'Không thể đọc token: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(ApiConstants.tokenKey);
    } catch (e) {
      throw CacheException(message: 'Không thể xóa token: $e');
    }
  }
}
