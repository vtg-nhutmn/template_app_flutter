import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/domain/profile/usecases/update_profile_usecase.dart';
import 'package:demo/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:demo/features/presentation/profile/bloc/edit_profile/edit_profile_event.dart';
import 'package:demo/features/presentation/profile/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late MockUpdateProfileUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUpdateProfileUseCase();
    registerFallbackValue(
      const UpdateProfileParams(displayName: '', phone: '', email: ''),
    );
  });

  EditProfileBloc buildBloc() => EditProfileBloc(mockUseCase);

  const tEvent = EditProfileSubmitted(
    displayName: 'Updated Name',
    phone: '0901234567',
    email: 'updated@example.com',
  );

  group('EditProfileBloc', () {
    test('initial state is EditProfileInitial', () {
      expect(buildBloc().state, isA<EditProfileInitial>());
    });

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileLoading, EditProfileSuccess] on successful update',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => right(unit));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [isA<EditProfileLoading>(), isA<EditProfileSuccess>()],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileLoading, EditProfileFailure] when update fails',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async => left(const ServerFailure(message: 'Cập nhật thất bại')),
        );
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<EditProfileLoading>(),
        isA<EditProfileFailure>().having(
          (s) => s.message,
          'message',
          'Cập nhật thất bại',
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileSuccess carries correct success message',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => right(unit));
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<EditProfileLoading>(),
        isA<EditProfileSuccess>().having(
          (s) => s.message,
          'message',
          'Cập nhật thông tin thành công',
        ),
      ],
    );
  });
}
