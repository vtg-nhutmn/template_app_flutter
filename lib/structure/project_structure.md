# Cấu trúc Project: architecture

## Thông tin chung

| Thuộc tính | Giá trị |
|---|---|
| **Package name** | `architecture` |
| **Flutter SDK** | `^3.9.2` |
| **Kiến trúc** | Clean Architecture + BLoC |
| **DI** | get_it (thủ công) |

---

## Dependencies

### Runtime
| Package | Version | Mục đích |
|---|---|---|
| `flutter_bloc` | ^8.1.6 | State management |
| `equatable` | ^2.0.5 | So sánh object |
| `get_it` | ^7.7.0 | Dependency Injection |
| `go_router` | ^14.0.0 | Navigation/Routing |
| `dio` | ^5.7.0 | HTTP client |
| `fpdart` | ^1.1.0 | Functional programming (Either, Option) |
| `flutter_secure_storage` | ^9.2.2 | Lưu token an toàn |
| `connectivity_plus` | ^6.1.1 | Kiểm tra kết nối mạng |

### Dev
| Package | Version | Mục đích |
|---|---|---|
| `flutter_lints` | ^5.0.0 | Lint rules |
| `bloc_test` | ^9.1.7 | Unit test cho BLoC |
| `mocktail` | ^1.0.4 | Mock objects trong test |

---

## Cấu trúc thư mục

```
lib/
├── main.dart                          # Entry point
│
├── app/                               # Cấu hình app toàn cục
│   ├── app.dart                       # Widget gốc (MaterialApp)
│   ├── router/
│   │   ├── app_router.dart            # Cấu hình GoRouter
│   │   └── app_routes.dart            # Định nghĩa các route constants
│   └── theme/
│       ├── app_colors.dart            # Bảng màu
│       ├── app_text_styles.dart       # Text styles
│       └── app_theme.dart             # ThemeData
│
├── core/                              # Tầng dùng chung toàn app
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL, endpoint paths
│   │   └── app_constants.dart         # Hằng số toàn app
│   ├── di/
│   │   ├── injection_container.dart   # Cấu hình DI thủ công (get_it)
│   │   └── injection_container.config.dart  # (Không dùng - file cũ generated)
│   ├── errors/
│   │   ├── exceptions.dart            # Custom exceptions
│   │   └── failures.dart              # Failure classes (dùng với fpdart)
│   ├── network/
│   │   ├── dio_client.dart            # Dio setup, interceptors (auth token)
│   │   └── network_info.dart          # Kiểm tra kết nối mạng
│   ├── storage/
│   │   └── secure_storage.dart        # Wrapper FlutterSecureStorage
│   ├── usecases/
│   │   └── usecase.dart               # Abstract UseCase<Type, Params>
│   └── utils/
│       ├── extensions.dart            # Dart extensions
│       └── validators.dart            # Hàm validate (email, password...)
│
└── features/                          # Các tính năng (feature-first)
    │
    ├── auth/                          # Tính năng: Xác thực
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_local_data_source.dart   # Đọc/ghi token local
    │   │   │   └── auth_remote_data_source.dart  # Gọi API login/logout
    │   │   ├── models/
    │   │   │   └── user_model.dart               # JSON model (extends UserEntity)
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart     # Impl AuthRepository
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart              # Entity thuần (không phụ thuộc framework)
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart          # Abstract AuthRepository
    │   │   └── usecases/
    │   │       ├── login_usecase.dart             # UseCase: đăng nhập
    │   │       └── logout_usecase.dart            # UseCase: đăng xuất
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart                # BLoC xử lý auth state
    │       │   ├── auth_event.dart               # Auth events
    │       │   └── auth_state.dart               # Auth states
    │       ├── pages/
    │       │   └── login_page.dart               # Màn hình đăng nhập
    │       └── widgets/
    │           ├── login_form_widget.dart         # Form username/password
    │           └── primary_button.dart            # Button tái sử dụng
    │
    └── profile/                       # Tính năng: Hồ sơ người dùng
        ├── data/
        │   ├── datasources/
        │   │   └── profile_remote_data_source.dart  # Gọi API lấy profile
        │   ├── models/
        │   │   └── profile_model.dart               # JSON model (extends ProfileEntity)
        │   └── repositories/
        │       └── profile_repository_impl.dart     # Impl ProfileRepository
        ├── domain/
        │   ├── entities/
        │   │   └── profile_entity.dart              # Entity thuần
        │   ├── repositories/
        │   │   └── profile_repository.dart          # Abstract ProfileRepository
        │   └── usecases/
        │       └── get_profile_usecase.dart         # UseCase: lấy thông tin profile
        └── presentation/
            ├── bloc/
            │   ├── profile_bloc.dart               # BLoC xử lý profile state
            │   ├── profile_event.dart              # Profile events
            │   └── profile_state.dart              # Profile states
            ├── pages/
            │   └── profile_page.dart              # Màn hình profile
            └── widgets/
                ├── profile_avatar_widget.dart     # Widget avatar
                └── profile_info_card_widget.dart  # Widget card thông tin
```

---

## Luồng dữ liệu (Data Flow)

```
UI (Page/Widget)
    │  dispatch Event
    ▼
BLoC
    │  call UseCase
    ▼
UseCase (Domain)
    │  call Repository (abstract)
    ▼
Repository Impl (Data)
    │  call DataSource (local/remote)
    ▼
DataSource
    │  (local) SecureStorage / (remote) DioClient → API
    ▼
Model → map → Entity → trả về qua Either<Failure, T>
```

---

## Dependency Injection

File: `lib/core/di/injection_container.dart`

Thứ tự đăng ký (external → core → data → domain → presentation):

```
FlutterSecureStorage   (lazySingleton)
Connectivity           (lazySingleton)
    │
    ▼
SecureStorage          (lazySingleton)
NetworkInfo            (lazySingleton)
DioClient              (lazySingleton)
    │
    ▼
AuthRemoteDataSource   (lazySingleton)
AuthLocalDataSource    (lazySingleton)
ProfileRemoteDataSource(lazySingleton)
    │
    ▼
AuthRepository         (lazySingleton)
ProfileRepository      (lazySingleton)
    │
    ▼
LoginUseCase           (factory)
LogoutUseCase          (factory)
GetProfileUseCase      (factory)
    │
    ▼
AuthBloc               (factory)
ProfileBloc            (factory)
```

> **lazySingleton**: tạo một lần, tái sử dụng.  
> **factory**: tạo mới mỗi lần gọi `getIt<T>()`.

---

## Quy ước đặt tên

| Loại | Pattern | Ví dụ |
|---|---|---|
| Entity | `<Name>Entity` | `UserEntity` |
| Model | `<Name>Model` | `UserModel` |
| Repository (abstract) | `<Name>Repository` | `AuthRepository` |
| Repository (impl) | `<Name>RepositoryImpl` | `AuthRepositoryImpl` |
| DataSource (abstract) | `<Name>DataSource` | `AuthRemoteDataSource` |
| DataSource (impl) | `<Name>DataSourceImpl` | `AuthRemoteDataSourceImpl` |
| UseCase | `<Action><Name>UseCase` | `LoginUseCase`, `GetProfileUseCase` |
| BLoC | `<Name>Bloc` | `AuthBloc` |
| Event | `<Name>Event` | `AuthEvent` |
| State | `<Name>State` | `AuthState` |
| Page | `<Name>Page` | `LoginPage` |
| Widget | `<Name>Widget` | `LoginFormWidget` |
