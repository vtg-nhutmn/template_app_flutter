class AppConfig {
  static String baseUrl = 'https://vinhtanfoods.dev/api-production';

  static const String defaultLocale = 'vi';

  static void configDev() {
    baseUrl = 'https://vinhtanfoods.dev/api-app';
  }
}
