import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<AuthRepository>());

/// Drives all routing decisions (splash -> onboarding/auth/home) — see
/// `app_router.dart`'s `refreshListenable`.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthFormState {
  const AuthFormState({this.isSubmitting = false, this.error});
  final bool isSubmitting;
  final String? error;

  AuthFormState copyWith({bool? isSubmitting, String? error}) =>
      AuthFormState(isSubmitting: isSubmitting ?? this.isSubmitting, error: error);
}

class AuthController extends StateNotifier<AuthFormState> {
  AuthController({
    required this._signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required this._signInWithGoogle,
    required this._signInAsChild,
    required this._signOut,
    required this._sendPasswordResetEmail,
  })  : _signUpWithEmail = signUpWithEmail,
        super(const AuthFormState());

  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignInAsChild _signInAsChild;
  final SignOut _signOut;
  final SendPasswordResetEmail _sendPasswordResetEmail;

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true, error: null);
    final result = await _signInWithEmail(email: email, password: password);
    state = state.copyWith(isSubmitting: false);
    return result.when(success: (_) {
      getIt<AnalyticsService>().logLogin('email');
      return true;
    }, failure: (f) {
      state = state.copyWith(error: f.message);
      return false;
    });
  }

  Future<bool> signUp({required String email, required String password, required String displayName}) async {
    state = state.copyWith(isSubmitting: true, error: null);
    final result = await _signUpWithEmail(email: email, password: password, displayName: displayName);
    state = state.copyWith(isSubmitting: false);
    return result.when(success: (_) {
      getIt<AnalyticsService>().logSignUp('email');
      return true;
    }, failure: (f) {
      state = state.copyWith(error: f.message);
      return false;
    });
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isSubmitting: true, error: null);
    final result = await _signInWithGoogle();
    state = state.copyWith(isSubmitting: false);
    return result.when(success: (_) {
      getIt<AnalyticsService>().logLogin('google');
      return true;
    }, failure: (f) {
      state = state.copyWith(error: f.message);
      return false;
    });
  }

  Future<bool> continueAsChild({required String displayName}) async {
    state = state.copyWith(isSubmitting: true, error: null);
    final result = await _signInAsChild(displayName: displayName);
    state = state.copyWith(isSubmitting: false);
    return result.when(success: (_) {
      getIt<AnalyticsService>().logLogin('child_mode');
      return true;
    }, failure: (f) {
      state = state.copyWith(error: f.message);
      return false;
    });
  }

  Future<bool> resetPassword(String email) async {
    final result = await _sendPasswordResetEmail(email);
    return result.when(success: (_) => true, failure: (f) {
      state = state.copyWith(error: f.message);
      return false;
    });
  }

  Future<void> signOut() => _signOut();
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthFormState>((ref) {
  return AuthController(
    signInWithEmail: getIt(),
    signUpWithEmail: getIt(),
    signInWithGoogle: getIt(),
    signInAsChild: getIt(),
    signOut: getIt(),
    sendPasswordResetEmail: getIt(),
  );
});
