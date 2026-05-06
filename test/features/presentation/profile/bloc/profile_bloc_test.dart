import 'package:bloc_test/bloc_test.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/core/usecases/usecase.dart';
import 'package:demo/features/domain/profile/entities/profile_entity.dart';
import 'package:demo/features/domain/profile/usecases/get_profile_usecase.dart';
import 'package:demo/features/presentation/profile/bloc/profile/profile_bloc.dart';
import 'package:demo/features/presentation/profile/bloc/profile/profile_event.dart';
import 'package:demo/features/presentation/profile/bloc/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

void main() {
  late MockGetProfileUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetProfileUseCase();
    registerFallbackValue(NoParams());
  });

  ProfileBloc buildBloc() => ProfileBloc(mockUseCase);

  const tProfile = ProfileEntity(
    uid: 'uid1',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    phone: '0901234567',
    isActive: true,
    role: false,
    createdAt: '2026-01-01',
  );

  group('ProfileBloc', () {
    test('initial state is ProfileInitial', () {
      expect(buildBloc().state, isA<ProfileInitial>());
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] on success',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => right(tProfile));
      },
      act: (bloc) => bloc.add(ProfileLoadRequested()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>().having((s) => s.profile, 'profile', tProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when use case fails',
      build: buildBloc,
      setUp: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async =>
              left(const ServerFailure(message: 'Không tìm thấy hồ sơ')),
        );
      },
      act: (bloc) => bloc.add(ProfileLoadRequested()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>().having(
          (s) => s.message,
          'message',
          'Không tìm thấy hồ sơ',
        ),
      ],
    );
  });
}
