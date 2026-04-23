import 'package:flutter/material.dart';

import '../core/routing/app_navigator.dart';
import '../core/routing/app_router.dart';
import '../core/themes/app_themes.dart';

class Bootstrap extends StatelessWidget {
  const Bootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VSA App',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.key,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppThemes.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
    );
  }
}
