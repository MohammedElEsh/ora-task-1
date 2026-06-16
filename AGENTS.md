# AGENTS.md — General Flutter/Clean Architecture Guidelines

This file provides **general, project-agnostic** guidance for working with Flutter projects using feature-first clean architecture, Cubit state management, and state-driven routing. Copy or adapt for any project.

---

## Core Principles

- **Feature-first**: Every feature is self-contained (`data/` + `presentation/`). Delete a feature folder → app still compiles.
- **Contract-driven data**: Repositories are `abstract` classes. Implementations are the only thing touching `ApiConsumer` / storage.
- **State-driven navigation**: UI never decides *where* the user goes. A single source of truth (`SessionManager`/`AppStatus`) drives redirects via GoRouter.
- **Theme-driven UI**: No hardcoded colors/sizes/text styles. Pull from `AppColors`, `AppTypography`, `theme.colorScheme`, `theme.textTheme`.
- **Localization by default**: No hardcoded user-facing strings. Use `.tr()` / translation keys.
- **Single-flight token refresh**: On 401, one refresh attempt; on failure → forced logout.

---

## Standard Feature Layout

```
features/<feature>/
├── data/
│   ├── models/         # Plain Dart classes (Equatable), JSON factories
│   └── repositories/   # Abstract + Impl, return Either<Failure, T>
└── presentation/
    ├── manager/        # Cubit + State (Equatable)
    ├── views/          # Screens (Scaffold + SafeArea + BlocBuilder)
    └── widgets/        # Reusable UI fragments consumed by views
```

---

## Common Cubit Pattern

```dart
// State (Equatable)
abstract class FeatureState extends Equatable { ... }
class FeatureInitial extends FeatureState { ... }
class FeatureLoading extends FeatureState { ... }
class FeatureLoaded extends FeatureState { ... }
class FeatureError extends FeatureState { ... }

// Cubit
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit(this._repo) : super(FeatureInitial());
  final FeatureRepository _repo;

  Future<void> loadData() async {
    emit(FeatureLoading());
    final result = await _repo.getData();
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
}
```

---

## Repository Pattern (Either<Failure, T>)

```dart
abstract class FeatureRepository {
  Future<Either<Failure, DataModel>> getData();
}

class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl(this._api);
  final ApiConsumer _api;

  @override
  Future<Either<Failure, DataModel>> getData() async {
    return safeCall(() async {
      final response = await _api.get(endpoint);
      return DataModel.fromJson(response);
    });
  }
}
```

---

## State-Driven Routing (GoRouter + SessionManager)

```dart
enum AppStatus { initial, onboardingRequired, unauthenticated, authenticatedNeedsSetup, authenticated }

class SessionManager extends ChangeNotifier {
  AppStatus _status = AppStatus.initial;
  AppStatus get status => _status;

  void login(String access, String refresh) { ... _status = AppStatus.authenticatedNeedsSetup; notifyListeners(); }
  void markReady() { _status = AppStatus.authenticated; notifyListeners(); }
  void logout() { _status = AppStatus.unauthenticated; notifyListeners(); }
  // onboarding, token refresh failure, etc.
}

// Router redirect:
redirect: (context, state) {
  final status = sl<SessionManager>().status;
  final location = state.matchedLocation;
  // Map status → allowed routes, redirect if needed
}
```

---

## Standard Git Workflow

- **Branch per feature**: `features/<feature>/<subtask>` (e.g., `features/auth/login`)
- **Commit often**, small atomic commits
- **Conventional commits**: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`
- **PR per branch** — clean history, easier review
- **Never commit secrets** (API keys, keystore passwords, etc.)

---

## Common Commands

```bash
# Dependencies
flutter pub get

# Run
flutter run

# Analysis
flutter analyze

# Tests
flutter test

# Format
dart format .

# Generate launcher icons
dart run flutter_launcher_icons

# Generate native splash
dart run flutter_native_splash:create
```

---

## Code Style Rules

- **No comments** unless explicitly requested
- **Equatable** for all models/states
- **`safeCall`** for all async operations returning `Either<Failure, T>`
- **FeedbackHandler** for toast/snackbar (success, error, info, warning)
- **LoggerService** for logging (not `print`)
- **ScreenUtil** for responsive sizing (`10.w`, `12.sp`, `20.h`)

---

## Project Setup Checklist (New Project)

- [ ] `flutter create --org com.example --platforms=android,ios,web,windows,macos`
- [ ] Add core dependencies: `flutter_bloc`, `go_router`, `dio`, `get_it`, `equatable`, `easy_localization`, `flutter_screenutil`, `google_fonts`, `hive_ce`, `flutter_secure_storage`, `shared_preferences`, `connectivity_plus`, `logger`
- [ ] Configure `analysis_options.yaml` (strict linting)
- [ ] Set up `get_it` DI container (`core/di/`)
- [ ] Set up `ApiConsumer` + `DioConsumer` + interceptors
- [ ] Set up `SessionManager` + `AppStatus` + GoRouter guard
- [ ] Add `LocalizationHelper` + translation assets
- [ ] Add `AppColors`, `AppTypography`, light/dark themes
- [ ] Add `Failure` hierarchy + `safeCall` helper
- [ ] Add `FeedbackHandler` + `FeedbackCard`
- [ ] Add `LoggerService` + `AppBlocObserver`
- [ ] Create first feature (e.g., `onboarding`) as reference

---

## Debug/Dev Tools

- `AppBlocObserver` — logs all Cubit state changes
- `DevTools` (in `core/dev/`) — debug-only utilities
- `flutter_animate` for micro-interactions
- `skeletonizer` for loading placeholders
