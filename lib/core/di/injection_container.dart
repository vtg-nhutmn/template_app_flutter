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
import 'package:demo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:demo/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:demo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:demo/features/auth/domain/usecases/register_usecase.dart';
import 'package:demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:demo/features/auth/presentation/bloc/register_bloc.dart';
import 'package:demo/features/home/data/datasources/product_remote_data_source.dart';
import 'package:demo/features/home/data/repositories/product_repository_impl.dart';
import 'package:demo/features/home/domain/repositories/product_repository.dart';
import 'package:demo/features/home/domain/usecases/add_product_usecase.dart';
import 'package:demo/features/home/domain/usecases/get_products_usecase.dart';
import 'package:demo/features/home/presentation/bloc/add_product_bloc.dart';
import 'package:demo/features/home/presentation/bloc/product_bloc.dart';
import 'package:demo/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:demo/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:demo/features/notifications/domain/repositories/notification_repository.dart';
import 'package:demo/features/notifications/domain/usecases/create_notification_usecase.dart';
import 'package:demo/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:demo/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:demo/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:demo/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:demo/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:demo/features/profile/domain/repositories/profile_repository.dart';
import 'package:demo/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:demo/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:demo/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:demo/features/profile/presentation/bloc/change_password_bloc.dart';
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
