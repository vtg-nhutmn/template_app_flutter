import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static final Map<String, WidgetBuilder> _routes = {};
  static String _initialRoute = '';

  static void register({
    required String initialRoute,
    required Map<String, WidgetBuilder> routes,
  }) {
    _initialRoute = initialRoute;
    _routes.addAll(routes);
  }

  static Map<String, WidgetBuilder> get routes => Map.unmodifiable(_routes);
  static String get initialRoute => _initialRoute;
}
