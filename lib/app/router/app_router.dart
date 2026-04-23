import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:demo/features/auth/presentation/pages/login_page.dart';
import 'package:demo/features/auth/presentation/pages/register_page.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:demo/features/profile/presentation/pages/change_password_page.dart';
import 'package:demo/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:demo/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const _publicRoutes = [AppRoutes.login, AppRoutes.register];

  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: _AuthBlocListenable(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final isPublic = _publicRoutes.contains(location);

      if (authState is AuthAuthenticated && location == AppRoutes.login) {
        return AppRoutes.profile;
      }

      if (authState is! AuthAuthenticated &&
          authState is! AuthLoading &&
          authState is! AuthInitial &&
          !isPublic) {
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
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) {
          final profile = state.extra as ProfileEntity;
          return EditProfilePage(profile: profile);
        },
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordPage(),
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
