import 'package:flutter/material.dart';
import 'package:vsa_model/app/bootstrap.dart';
import 'package:vsa_model/core/network/api_client.dart';
import 'package:vsa_model/core/routing/app_navigator.dart';
import 'package:vsa_model/core/routing/app_router.dart';
import 'package:vsa_model/features/login/login_route.dart';
import 'package:vsa_model/features/view_profile/view_profile_route.dart';
import 'app/app_config.dart';

void main() {
  AppConfig.configDev();

  AppRouter.register(
    initialRoute: LoginRoute.path,
    routes: {
      ...LoginRoute.definitions(
        onLoginSuccess: () =>
            AppNavigator.pushReplacementNamed(ViewProfileRoute.path),
      ),
      ...ViewProfileRoute.definitions,
    },
  );

  ApiClient.onUnauthorized = () {
    AppNavigator.pushReplacementNamed(LoginRoute.path);
  };

  runApp(const Bootstrap());
}
