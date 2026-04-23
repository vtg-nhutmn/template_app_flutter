import 'package:demo/core/di/injection_container.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final GoRouterWrapper _routerWrapper;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(AuthCheckRequested());
    _routerWrapper = GoRouterWrapper(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Vinh Tan Foods',
        theme: AppTheme.light,
        routerConfig: _routerWrapper.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class GoRouterWrapper {
  late final router = AppRouter.router(_authBloc);
  final AuthBloc _authBloc;
  GoRouterWrapper(this._authBloc);
}
