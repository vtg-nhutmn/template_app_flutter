import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/session/user_session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserSessionCubit', () {
    late UserSessionCubit cubit;

    setUp(() {
      cubit = UserSessionCubit();
    });

    tearDown(() => cubit.close());

    test('initial state has isAdmin=false and unreadNotificationCount=0', () {
      expect(cubit.state.isAdmin, false);
      expect(cubit.state.unreadNotificationCount, 0);
    });

    blocTest<UserSessionCubit, UserSessionState>(
      'updateSession sets isAdmin and preserves unreadNotificationCount',
      build: () => UserSessionCubit(),
      seed: () =>
          const UserSessionState(isAdmin: false, unreadNotificationCount: 5),
      act: (cubit) => cubit.updateSession(isAdmin: true),
      expect: () => [
        const UserSessionState(isAdmin: true, unreadNotificationCount: 5),
      ],
    );

    blocTest<UserSessionCubit, UserSessionState>(
      'updateSession with isAdmin=false preserves unreadNotificationCount',
      build: () => UserSessionCubit(),
      seed: () =>
          const UserSessionState(isAdmin: true, unreadNotificationCount: 3),
      act: (cubit) => cubit.updateSession(isAdmin: false),
      expect: () => [
        const UserSessionState(isAdmin: false, unreadNotificationCount: 3),
      ],
    );

    blocTest<UserSessionCubit, UserSessionState>(
      'updateUnreadCount sets count and preserves isAdmin',
      build: () => UserSessionCubit(),
      seed: () =>
          const UserSessionState(isAdmin: true, unreadNotificationCount: 0),
      act: (cubit) => cubit.updateUnreadCount(7),
      expect: () => [
        const UserSessionState(isAdmin: true, unreadNotificationCount: 7),
      ],
    );

    blocTest<UserSessionCubit, UserSessionState>(
      'updateUnreadCount with 0 preserves isAdmin',
      build: () => UserSessionCubit(),
      seed: () =>
          const UserSessionState(isAdmin: true, unreadNotificationCount: 5),
      act: (cubit) => cubit.updateUnreadCount(0),
      expect: () => [
        const UserSessionState(isAdmin: true, unreadNotificationCount: 0),
      ],
    );

    blocTest<UserSessionCubit, UserSessionState>(
      'clearSession resets to default state',
      build: () => UserSessionCubit(),
      seed: () =>
          const UserSessionState(isAdmin: true, unreadNotificationCount: 10),
      act: (cubit) => cubit.clearSession(),
      expect: () => [
        const UserSessionState(isAdmin: false, unreadNotificationCount: 0),
      ],
    );
  });
}
