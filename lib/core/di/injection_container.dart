import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:demo/core/network/dio_client.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/core/storage/secure_storage.dart';
import 'package:demo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:demo/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:demo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:demo/features/auth/domain/usecases/register_usecase.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/register_bloc.dart';
import 'package:demo/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:demo/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:demo/features/profile/domain/repositories/profile_repository.dart';
import 'package:demo/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:demo/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:demo/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:demo/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:demo/features/profile/presentation/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Infrastructure
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(getIt()));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerFactory<IsLoggedInUseCase>(() => IsLoggedInUseCase(getIt()));
  getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory<RegisterBloc>(() => RegisterBloc(getIt()));

  // Profile
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );
  getIt.registerFactory<GetProfileUseCase>(() => GetProfileUseCase(getIt()));
  getIt.registerFactory<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt()),
  );
  getIt.registerFactory<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(getIt()),
  );
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt()));
  getIt.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(getIt(), getIt()),
  );
}
