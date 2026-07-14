# Example — Flutter + Riverpod

This example shows how Engineering OS frontend architecture (MVVM + Clean Architecture + Feature-First) maps to a Flutter project using Riverpod for state management and dependency injection.

---

## Architecture Mapping

| Engineering OS Concept | Flutter / Riverpod Implementation |
|---|---|
| ViewModel | `StateNotifier` or `Notifier` class |
| View | `ConsumerWidget` or `ConsumerStatefulWidget` |
| Repository Interface | Abstract Dart class in `domain/repositories/` |
| Repository Implementation | Concrete class in `data/repositories/` |
| Use Case | Plain Dart class with a single `call()` method |
| Dependency Injection | Riverpod `Provider` / `NotifierProvider` |
| Domain Entity | Plain Dart class (with `freezed` for immutability if needed) |

---

## Folder Structure

```
lib/
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart          ← abstract class
│       │   └── use_cases/
│       │       ├── login_use_case.dart
│       │       └── logout_use_case.dart
│       ├── data/
│       │   ├── repositories/
│       │   │   └── auth_repository_impl.dart     ← implements auth_repository.dart
│       │   ├── datasources/
│       │   │   ├── auth_remote_datasource.dart
│       │   │   └── auth_local_datasource.dart
│       │   └── models/
│       │       └── user_model.dart               ← JSON mapping, not a domain entity
│       └── presentation/
│           ├── viewmodels/
│           │   └── login_viewmodel.dart          ← StateNotifier or Notifier
│           ├── views/
│           │   └── login_screen.dart             ← ConsumerWidget
│           └── widgets/
│               └── login_form.dart
├── core/
│   ├── network/
│   │   └── http_client.dart
│   ├── storage/
│   │   └── secure_storage.dart
│   └── providers/
│       └── core_providers.dart
└── shared/
    ├── ui/
    │   ├── theme.dart
    │   └── widgets/
    │       └── primary_button.dart
    └── utils/
        └── validators.dart
```

---

## Key Patterns

### Domain Entity (no Flutter imports)

```dart
// features/auth/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });
}
```

---

### Repository Interface (domain layer)

```dart
// features/auth/domain/repositories/auth_repository.dart

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
}
```

---

### Use Case (application layer)

```dart
// features/auth/domain/use_cases/login_use_case.dart

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
```

---

### ViewModel (presentation layer — StateNotifier)

```dart
// features/auth/presentation/viewmodels/login_viewmodel.dart

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(LoginState.initial());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _loginUseCase(email: email, password: password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

The ViewModel never calls the repository directly.

The ViewModel never knows about HTTP, databases, or local storage.

---

### Riverpod Providers (dependency wiring)

```dart
// features/auth/presentation/viewmodels/login_viewmodel.dart (providers section)

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.read(loginUseCaseProvider));
});
```

---

### View (ConsumerWidget — no logic)

```dart
// features/auth/presentation/views/login_screen.dart

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      body: state.isLoading
          ? const CircularProgressIndicator()
          : LoginForm(
              onSubmit: (email, password) =>
                  viewModel.login(email: email, password: password),
              error: state.error,
            ),
    );
  }
}
```

The View contains zero business logic.

All user interactions are delegated to the ViewModel.

---

### Repository Implementation (data layer)

```dart
// features/auth/data/repositories/auth_repository_impl.dart

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  @override
  Future<User> login({required String email, required String password}) async {
    final userModel = await _remote.login(email: email, password: password);
    await _local.saveToken(userModel.token);
    return userModel.toDomain();   // maps to domain entity
  }
}
```

---

## Dependency Direction

```
LoginScreen (View)
  └── LoginViewModel (StateNotifier)
        └── LoginUseCase
              └── AuthRepository (interface)
                    └── AuthRepositoryImpl (implements)
                          └── AuthRemoteDataSource
```

Flutter, Riverpod, and HTTP never appear above the data layer.

---

## Testing

```dart
// Unit test — ViewModel with mocked use case
test('login updates state to authenticated on success', () async {
  final mockUseCase = MockLoginUseCase();
  when(mockUseCase.call(email: any, password: any))
      .thenAnswer((_) async => User(id: '1', email: 'a@b.com', name: 'Alice'));

  final viewModel = LoginViewModel(mockUseCase);
  await viewModel.login(email: 'a@b.com', password: 'secret');

  expect(viewModel.state.user?.email, 'a@b.com');
  expect(viewModel.state.isLoading, false);
});
```
