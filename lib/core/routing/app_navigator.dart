import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static NavigatorState get _navigator => key.currentState!;

  static void pushReplacementNamed(String routeName) {
    _navigator.pushNamedAndRemoveUntil(routeName, (_) => false);
  }
}
