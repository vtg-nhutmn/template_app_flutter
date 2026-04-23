import 'package:flutter/material.dart';

import 'login_page.dart';

class LoginRoute {
  LoginRoute._();

  static const String path = '/login';

  static Map<String, WidgetBuilder> definitions({
    VoidCallback? onLoginSuccess,
  }) => {path: (_) => LoginPage(onLoginSuccess: onLoginSuccess)};
}
