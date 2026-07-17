import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Contract the presentation layer codes against. Two implementations
/// exist behind [AuthRepositoryImpl]: Firebase-backed and local-only —
/// callers never need to know which one is active.
abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  UserEntity? get currentUser;

  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signInWithGoogle();

  Future<Result<UserEntity>> signInAsChild({required String displayName});

  Future<Result<void>> sendPasswordResetEmail(String email);

  Future<Result<void>> signOut();
}
