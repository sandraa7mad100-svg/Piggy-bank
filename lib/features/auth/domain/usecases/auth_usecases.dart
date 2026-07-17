import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Auth use cases. Kept in one file (rather than one class per file) since
/// each is a thin, single-purpose wrapper around [AuthRepository] — this
/// keeps the use-case layer honest (a real seam for business rules/testing)
/// without a proliferation of near-empty files.
class SignInWithEmail {
  const SignInWithEmail(this._repository);
  final AuthRepository _repository;

  Future<Result<UserEntity>> call({required String email, required String password}) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}

class SignUpWithEmail {
  const SignUpWithEmail(this._repository);
  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _repository.signUpWithEmail(email: email, password: password, displayName: displayName);
  }
}

class SignInWithGoogle {
  const SignInWithGoogle(this._repository);
  final AuthRepository _repository;

  Future<Result<UserEntity>> call() => _repository.signInWithGoogle();
}

class SignInAsChild {
  const SignInAsChild(this._repository);
  final AuthRepository _repository;

  Future<Result<UserEntity>> call({required String displayName}) {
    return _repository.signInAsChild(displayName: displayName);
  }
}

class SignOut {
  const SignOut(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.signOut();
}

class SendPasswordResetEmail {
  const SendPasswordResetEmail(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call(String email) => _repository.sendPasswordResetEmail(email);
}
