import 'package:bloc_test/bloc_test.dart';
import 'package:demo/features/presentation/auth/bloc/auth_bloc.dart';
import 'package:demo/features/presentation/auth/bloc/auth_event.dart';
import 'package:demo/features/presentation/auth/bloc/auth_state.dart';
import 'package:demo/features/presentation/auth/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

Widget _buildSubject(AuthBloc bloc) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>.value(
      value: bloc,
      child: const Scaffold(
        body: SingleChildScrollView(child: LoginFormWidget()),
      ),
    ),
  );
}

void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() => mockBloc.close());

  group('LoginFormWidget', () {
    testWidgets('renders username and password fields and login button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(mockBloc));

      expect(find.text('Tên đăng nhập'), findsOneWidget);
      expect(find.text('Mật khẩu'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
    });

    testWidgets('shows username validation error when submitted empty', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(mockBloc));

      await tester.tap(find.text('Đăng nhập'));
      await tester.pump();

      expect(find.text('Tên đăng nhập không được để trống'), findsOneWidget);
    });

    testWidgets(
      'shows password validation error when only username is filled',
      (tester) async {
        await tester.pumpWidget(_buildSubject(mockBloc));

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Tên đăng nhập'),
          'validuser',
        );
        await tester.tap(find.text('Đăng nhập'));
        await tester.pump();

        expect(find.text('Mật khẩu không được để trống'), findsOneWidget);
      },
    );

    testWidgets('dispatches AuthLoginRequested when form is valid', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(mockBloc));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tên đăng nhập'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mật khẩu'),
        'password123',
      );
      await tester.tap(find.text('Đăng nhập'));
      await tester.pump();

      verify(
        () => mockBloc.add(
          const AuthLoginRequested(
            username: 'testuser',
            password: 'password123',
          ),
        ),
      ).called(1);
    });

    testWidgets('shows loading indicator when state is AuthLoading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AuthLoading());
      await tester.pumpWidget(_buildSubject(mockBloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is AuthError', (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const AuthError(message: 'Sai mật khẩu'));
      whenListen(
        mockBloc,
        Stream.fromIterable([const AuthError(message: 'Sai mật khẩu')]),
      );

      await tester.pumpWidget(_buildSubject(mockBloc));
      await tester.pump();

      expect(find.text('Sai mật khẩu'), findsOneWidget);
    });
  });
}
