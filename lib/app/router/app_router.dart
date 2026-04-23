import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:demo/features/auth/presentation/pages/login_page.dart';
import 'package:demo/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: _AuthBlocListenable(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (authState is AuthAuthenticated && isOnLogin) {
        return AppRoutes.profile;
      }

      if (authState is! AuthAuthenticated &&
          authState is! AuthLoading &&
          authState is! AuthInitial &&
          !isOnLogin) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}

class _AuthBlocListenable extends ChangeNotifier {
  final AuthBloc _authBloc;

  _AuthBlocListenable(this._authBloc) {
    _authBloc.stream.listen((_) => notifyListeners());
  }
}
