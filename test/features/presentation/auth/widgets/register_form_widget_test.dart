import 'package:bloc_test/bloc_test.dart';
import 'package:demo/features/presentation/auth/bloc/register_bloc.dart';
import 'package:demo/features/presentation/auth/bloc/register_event.dart';
import 'package:demo/features/presentation/auth/bloc/register_state.dart';
import 'package:demo/features/presentation/auth/widgets/register_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

Widget _buildSubject(RegisterBloc bloc) {
  return MaterialApp(
    home: BlocProvider<RegisterBloc>.value(
      value: bloc,
      child: const Scaffold(
        body: SingleChildScrollView(child: RegisterFormWidget()),
      ),
    ),
  );
}

void main() {
  late MockRegisterBloc mockBloc;

  setUp(() {
    mockBloc = MockRegisterBloc();
    when(() => mockBloc.state).thenReturn(RegisterInitial());
  });

  tearDown(() => mockBloc.close());

  group('RegisterFormWidget', () {
    testWidgets('renders all required fields', (tester) async {
      await tester.pumpWidget(_buildSubject(mockBloc));

      expect(find.text('Tên đăng nhập'), findsOneWidget);
      expect(find.text('Họ và tên'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Số điện thoại'), findsOneWidget);
      expect(find.text('Đăng ký'), findsOneWidget);
    });

    testWidgets('shows validation errors when submitted with empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(mockBloc));

      await tester.tap(find.text('Đăng ký'));
      await tester.pump();

      expect(find.text('Tên đăng nhập không được để trống'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is RegisterLoading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(RegisterLoading());
      await tester.pumpWidget(_buildSubject(mockBloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('dispatches RegisterSubmitted when form is valid', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(mockBloc));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tên đăng nhập'),
        'newuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Họ và tên'),
        'New User',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'new@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Số điện thoại'),
        '0901234567',
      );
      final passwordFields = find.byType(TextFormField);
      await tester.enterText(passwordFields.at(4), 'password123');
      await tester.enterText(passwordFields.at(5), 'password123');

      await tester.tap(find.text('Đăng ký'));
      await tester.pump();

      verify(
        () => mockBloc.add(
          const RegisterSubmitted(
            username: 'newuser',
            displayName: 'New User',
            email: 'new@example.com',
            phone: '0901234567',
            password: 'password123',
          ),
        ),
      ).called(1);
    });

    testWidgets('shows error message when state is RegisterFailure', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const RegisterFailure(message: 'Email đã tồn tại'));
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const RegisterFailure(message: 'Email đã tồn tại'),
        ]),
      );

      await tester.pumpWidget(_buildSubject(mockBloc));
      await tester.pump();

      expect(find.text('Email đã tồn tại'), findsOneWidget);
    });
  });
}
