import 'package:demo/app/app.dart';
import 'package:demo/core/config/app_config.dart';
import 'package:demo/core/di/injection_container.dart';
import 'package:demo/core/services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies(AppConfig.stg());
  await getIt<FcmService>().init();
  runApp(const App());
}
