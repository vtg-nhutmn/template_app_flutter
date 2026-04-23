import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:architecture/core/network/dio_client.dart';
import 'package:architecture/core/network/network_info.dart';
import 'package:architecture/core/storage/secure_storage.dart';
import 'package:architecture/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:architecture/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:architecture/features/auth/domain/usecases/login_usecase.dart';
import 'package:architecture/features/auth/domain/usecases/logout_usecase.dart';
import 'package:architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:architecture/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:architecture/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:architecture/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:architecture/features/profile/presentation/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(getIt()));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerFactory<IsLoggedInUseCase>(() => IsLoggedInUseCase(getIt()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory<GetProfileUseCase>(() => GetProfileUseCase(getIt()));
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt()));
}
