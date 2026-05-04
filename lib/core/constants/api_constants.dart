import 'package:demo/core/config/app_config.dart';
import 'package:demo/core/di/injection_container.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => getIt<AppConfig>().apiBaseUrl;
  static const String tokenKey = 'access_token';

  // Endpoints
  static const String signin = '/auth/signin';
  static const String me = '/auth/me';
}
