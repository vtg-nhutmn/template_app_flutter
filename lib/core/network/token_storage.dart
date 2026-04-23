class TokenStorage {
  TokenStorage._();

  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static void save(String token) => _accessToken = token;

  static void clear() => _accessToken = null;
}
