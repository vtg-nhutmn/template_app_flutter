import 'package:demo/core/di/injection_container.dart';
import 'package:demo/core/services/fcm_service.dart';
import 'package:demo/core/session/user_session_cubit.dart';
import 'package:demo/core/storage/secure_storage.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/auth_event.dart';
import 'package:demo/features/auth/presentation/bloc/auth_state.dart';
import 'package:demo/features/home/presentation/bloc/add_product_bloc.dart';
import 'package:demo/features/home/presentation/bloc/add_product_state.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:demo/features/notifications/domain/usecases/create_notification_usecase.dart';
import 'package:demo/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:demo/features/notifications/presentation/bloc/notification_event.dart';
import 'package:demo/features/notifications/presentation/bloc/notification_state.dart';
import 'package:demo/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:demo/features/profile/presentation/bloc/profile_event.dart';
import 'package:demo/features/profile/presentation/bloc/profile_state.dart';
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
  late final AddProductBloc _addProductBloc;
  late final ProfileBloc _profileBloc;
  late final NotificationBloc _notificationBloc;
  late final UserSessionCubit _userSessionCubit;
  late final FcmService _fcmService;
  late final SecureStorage _secureStorage;
  late final GoRouterWrapper _routerWrapper;

  static const _seenIdsKey = 'seen_notification_ids';
  final Set<String> _seenNotificationIds = {};
  bool _seenIdsLoaded = false;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(AuthCheckRequested());
    _addProductBloc = getIt<AddProductBloc>();
    _profileBloc = getIt<ProfileBloc>();
    _notificationBloc = getIt<NotificationBloc>();
    _userSessionCubit = getIt<UserSessionCubit>();
    _fcmService = getIt<FcmService>();
    _secureStorage = getIt<SecureStorage>();
    _routerWrapper = GoRouterWrapper(_authBloc);
    _fcmService.setupTapHandlers((route) {
      _routerWrapper.router.go(route);
    });
    _loadSeenIds();
  }

  Future<void> _loadSeenIds() async {
    final stored = await _secureStorage.read(_seenIdsKey);
    if (stored != null && stored.isNotEmpty) {
      _seenNotificationIds.addAll(stored.split(','));
    }
    _seenIdsLoaded = true;
  }

  Future<void> _persistSeenIds() async {
    await _secureStorage.write(_seenIdsKey, _seenNotificationIds.join(','));
  }

  @override
  void dispose() {
    _authBloc.close();
    _addProductBloc.close();
    _profileBloc.close();
    _notificationBloc.close();
    _userSessionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _addProductBloc),
        BlocProvider.value(value: _profileBloc),
        BlocProvider.value(value: _notificationBloc),
        BlocProvider.value(value: _userSessionCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddProductBloc, AddProductState>(
            listener: (context, state) {
              if (state is AddProductSuccess) {
                context.read<NotificationBloc>().add(
                  NotificationCreateRequested(
                    CreateNotificationParams(
                      title: 'Sản phẩm mới',
                      body:
                          'Sản phẩm "${state.productName}" vừa được thêm vào danh sách.',
                      type: 'product_added',
                      isGlobal: true,
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                _profileBloc.add(ProfileLoadRequested());
                _notificationBloc.add(const NotificationsSubscribeRequested());
                _fcmService.saveTokenForUser();
              }
              if (state is AuthUnauthenticated) {
                _userSessionCubit.clearSession();
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                _userSessionCubit.updateSession(isAdmin: state.profile.role);
              }
            },
          ),
          BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is! NotificationsLoaded) return;
              _userSessionCubit.updateUnreadCount(state.unreadCount);
              if (!_seenIdsLoaded) return;
              final List<NotificationEntity> newOnes = state.notifications
                  .where((n) => !_seenNotificationIds.contains(n.id))
                  .toList();
              _seenNotificationIds.addAll(state.notifications.map((n) => n.id));
              _persistSeenIds();
              for (final notif in newOnes) {
                _fcmService.showLocalNotification(
                  title: notif.title,
                  body: notif.body,
                );
              }
            },
          ),
        ],
        child: MaterialApp.router(
          title: 'Demo App',
          theme: AppTheme.light,
          routerConfig: _routerWrapper.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class GoRouterWrapper {
  late final router = AppRouter.router(_authBloc);
  final AuthBloc _authBloc;
  GoRouterWrapper(this._authBloc);
}
