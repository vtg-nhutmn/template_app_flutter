import 'app_environment.dart';

class AppConfig {
  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
  });

  factory AppConfig.dev() => const AppConfig(
        environment: AppEnvironment.dev,
        appName: 'Demo Dev',
        apiBaseUrl: 'https://vinhtanfoods.dev/api-app',
      );

  factory AppConfig.stg() => const AppConfig(
        environment: AppEnvironment.stg,
        appName: 'Demo Stg',
        apiBaseUrl: 'https://vinhtanfoods.dev/api-app',
      );

  factory AppConfig.prod() => const AppConfig(
        environment: AppEnvironment.prod,
        appName: 'Demo',
        apiBaseUrl: 'https://vinhtanfoods.com/api-app',
      );

  bool get isDev => environment == AppEnvironment.dev;
  bool get isStg => environment == AppEnvironment.stg;
  bool get isProd => environment == AppEnvironment.prod;
}
