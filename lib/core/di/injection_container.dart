import 'package:demo/core/config/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:demo/core/network/network_info.dart';
import 'package:demo/core/services/fcm_service.dart';
import 'package:demo/core/session/user_session_cubit.dart';
import 'package:demo/core/storage/secure_storage.dart';
import 'package:demo/features/data/auth/datasources/auth_remote_data_source.dart';
import 'package:demo/features/data/auth/repositories/auth_repository_impl.dart';
import 'package:demo/features/domain/auth/repositories/auth_repository.dart';
import 'package:demo/features/domain/auth/usecases/is_logged_in_usecase.dart';
import 'package:demo/features/domain/auth/usecases/login_usecase.dart';
import 'package:demo/features/domain/auth/usecases/logout_usecase.dart';
import 'package:demo/features/domain/auth/usecases/register_usecase.dart';
import 'package:demo/features/presentation/auth/bloc/auth_bloc.dart';
import 'package:demo/features/presentation/auth/bloc/register_bloc.dart';
import 'package:demo/features/data/home/datasources/product_remote_data_source.dart';
import 'package:demo/features/data/home/repositories/product_repository_impl.dart';
import 'package:demo/features/domain/home/repositories/product_repository.dart';
import 'package:demo/features/domain/home/usecases/add_product_usecase.dart';
import 'package:demo/features/domain/home/usecases/get_products_usecase.dart';
import 'package:demo/features/presentation/home/bloc/add_product_bloc.dart';
import 'package:demo/features/presentation/home/bloc/product_bloc.dart';
import 'package:demo/features/data/notifications/datasources/notification_remote_data_source.dart';
import 'package:demo/features/data/notifications/repositories/notification_repository_impl.dart';
import 'package:demo/features/domain/notifications/repositories/notification_repository.dart';
import 'package:demo/features/domain/notifications/usecases/create_notification_usecase.dart';
import 'package:demo/features/domain/notifications/usecases/get_notifications_usecase.dart';
import 'package:demo/features/domain/notifications/usecases/mark_notification_read_usecase.dart';
import 'package:demo/features/presentation/notifications/bloc/notification_bloc.dart';
import 'package:demo/features/data/profile/datasources/profile_remote_data_source.dart';
import 'package:demo/features/data/profile/repositories/profile_repository_impl.dart';
import 'package:demo/features/domain/profile/repositories/profile_repository.dart';
import 'package:demo/features/domain/profile/usecases/change_password_usecase.dart';
import 'package:demo/features/domain/profile/usecases/get_profile_usecase.dart';
import 'package:demo/features/domain/profile/usecases/update_profile_usecase.dart';
import 'package:demo/features/presentation/profile/bloc/change_password/change_password_bloc.dart';
import 'package:demo/features/presentation/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:demo/features/presentation/profile/bloc/profile/profile_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies(AppConfig config) {
  getIt.registerSingleton<AppConfig>(config);

  // Infrastructure
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(getIt()));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<FcmService>(
    () => FcmService(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton<UserSessionCubit>(() => UserSessionCubit());

  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
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
  getIt.registerLazySingleton<ProfileBloc>(() => ProfileBloc(getIt()));
  getIt.registerFactory<EditProfileBloc>(() => EditProfileBloc(getIt()));
  getIt.registerFactory<ChangePasswordBloc>(() => ChangePasswordBloc(getIt()));

  // Home / Products
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerFactory<GetProductsUseCase>(() => GetProductsUseCase(getIt()));
  getIt.registerFactory<AddProductUseCase>(() => AddProductUseCase(getIt()));
  getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt()));
  getIt.registerLazySingleton<AddProductBloc>(() => AddProductBloc(getIt()));

  // Notifications
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );
  getIt.registerFactory<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt()),
  );
  getIt.registerFactory<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt()),
  );
  getIt.registerFactory<CreateNotificationUseCase>(
    () => CreateNotificationUseCase(getIt()),
  );
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(getIt(), getIt(), getIt(), getIt()),
  );
}
