import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/firebase_bootstrap.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Routes every auth operation to Firebase when [FirebaseBootstrap] managed
/// to initialize, and to a local, on-device implementation otherwise — so
/// the app is fully usable (signup/login/kid-mode) before a real Firebase
/// project is wired in. Every successful result is also cached locally so
/// Home/Settings can render instantly and survive offline restarts.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    AuthRemoteDataSource? remoteDataSource,
  })  : _local = localDataSource,
        _remote = remoteDataSource;

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource? _remote;

  bool get _online => FirebaseBootstrap.isAvailable && _remote != null;

  @override
  Stream<UserEntity?> get authStateChanges {
    if (_online) {
      return _remote!.authStateChanges().map((model) => model?.toEntity());
    }
    // Offline: live-updating stream backed by AuthLocalDataSource, so
    // sign-up/sign-in/Kid-Mode/sign-out are reflected immediately (this is
    // what GoRouter's redirect listens to — see _AuthRefreshNotifier).
    return _local.watchCachedUser().map((model) => model?.toEntity());
  }

  @override
  UserEntity? get currentUser {
    if (_online) return _remote!.currentUser?.toEntity();
    return _local.getCachedUser()?.toEntity();
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final model = _online
          ? await _remote!.signUpWithEmail(email: email, password: password, displayName: displayName)
          : await _local.registerLocalAccount(email: email, password: password, displayName: displayName);
      await _local.cacheUser(model);
      return Result.success(model.toEntity());
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (e, st) {
      appLogger.e('signUpWithEmail failed', error: e, stackTrace: st);
      return Result.failure(AuthFailure('Sign up failed: $e'));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithEmail({required String email, required String password}) async {
    try {
      final model = _online
          ? await _remote!.signInWithEmail(email: email, password: password)
          : await _local.signInLocalAccount(email: email, password: password);
      await _local.cacheUser(model);
      return Result.success(model.toEntity());
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (e, st) {
      appLogger.e('signInWithEmail failed', error: e, stackTrace: st);
      return Result.failure(AuthFailure('Sign in failed: $e'));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    if (!_online) {
      return const Result.failure(
        AuthFailure('Google sign-in needs an internet connection and a configured Firebase project.'),
      );
    }
    try {
      final model = await _remote!.signInWithGoogle();
      await _local.cacheUser(model);
      return Result.success(model.toEntity());
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (e, st) {
      appLogger.e('signInWithGoogle failed', error: e, stackTrace: st);
      return const Result.failure(AuthFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signInAsChild({required String displayName}) async {
    try {
      final model = _online
          ? await _remote!.signInAsChild(displayName: displayName)
          : await _local.createChildAccount(displayName: displayName);
      await _local.cacheUser(model);
      return Result.success(model.toEntity());
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (e, st) {
      appLogger.e('signInAsChild failed', error: e, stackTrace: st);
      return Result.failure(AuthFailure('Could not start Kid Mode: $e'));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    if (!_online) {
      return const Result.failure(
        AuthFailure('Password reset emails need an internet connection and a configured Firebase project.'),
      );
    }
    try {
      await _remote!.sendPasswordResetEmail(email);
      return const Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      if (_online) await _remote!.signOut();
      await _local.clearSession();
      return const Result.success(null);
    } catch (e, st) {
      appLogger.e('signOut failed', error: e, stackTrace: st);
      return const Result.failure(AuthFailure('Could not sign out.'));
    }
  }
}
