import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/hive_boxes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

/// Handles everything about auth that stays on-device:
///  - caching the signed-in [UserModel] so Home/Settings render offline
///  - a local, salted-hash credential store used ONLY when Firebase isn't
///    configured (see [FirebaseBootstrap]), so email/password + "Kid mode"
///    auth still work end-to-end in a fully offline demo. Passwords are
///    never stored in plaintext, on-device or otherwise.
class AuthLocalDataSource {
  AuthLocalDataSource(this._secureStorage);

  final SecureStorageService _secureStorage;
  static const _uuid = Uuid();
  static const _currentUserIdKey = 'current_user_id';

  /// Broadcasts every change to the cached session so
  /// [AuthRepositoryImpl.authStateChanges] can push live updates in
  /// offline mode — without this, GoRouter never learns that a
  /// sign-up/sign-in/Kid-Mode call succeeded, and the user gets stuck on
  /// the auth screen even though the account was created correctly.
  final _sessionController = StreamController<UserModel?>.broadcast();

  Box<UserModel> get _box => Hive.box<UserModel>(HiveBoxes.userProfile);

  Future<void> cacheUser(UserModel user) async {
    await _box.put(user.id, user);
    await _secureStorage.write(_currentUserIdKey, user.id);
    _sessionController.add(user);
  }

  UserModel? getCachedUser() {
    return _box.values.isEmpty ? null : _box.get(_box.keys.last);
  }

  /// Emits the current cached session immediately, then again on every
  /// [cacheUser] / [clearSession] call.
  Stream<UserModel?> watchCachedUser() async* {
    yield getCachedUser();
    yield* _sessionController.stream;
  }

  Future<String?> getCurrentUserId() => _secureStorage.read(_currentUserIdKey);

  Future<void> clearSession() async {
    await _secureStorage.delete(_currentUserIdKey);
    _sessionController.add(null);
  }

  Future<void> clearAll() async {
    await _box.clear();
    await _secureStorage.deleteAll();
    _sessionController.add(null);
  }

  // --- Local (offline) credential store ---------------------------------

  String _credentialKey(String email) => 'cred_${email.trim().toLowerCase()}';

  String _hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt:$password')).toString();
  }

  Future<UserModel> registerLocalAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final key = _credentialKey(email);
    final existing = await _secureStorage.read(key);
    if (existing != null) {
      throw const AuthException('An account with this email already exists.');
    }

    final salt = _uuid.v4();
    final hash = _hash(password, salt);
    await _secureStorage.write(key, '$salt:$hash');

    final user = UserModel(
      id: _uuid.v4(),
      email: email.trim().toLowerCase(),
      displayName: displayName,
      isChildMode: false,
      createdAt: DateTime.now(),
    );
    await cacheUser(user);
    return user;
  }

  Future<UserModel> signInLocalAccount({
    required String email,
    required String password,
  }) async {
    final key = _credentialKey(email);
    final stored = await _secureStorage.read(key);
    if (stored == null) {
      throw const AuthException('No account found for this email.');
    }
    final parts = stored.split(':');
    final salt = parts[0];
    final expectedHash = parts[1];
    if (_hash(password, salt) != expectedHash) {
      throw const AuthException('Incorrect password.');
    }

    final cached = _box.values.cast<UserModel?>().firstWhere(
          (u) => u?.email == email.trim().toLowerCase(),
          orElse: () => null,
        );
    if (cached == null) {
      throw const AuthException('Account data is missing locally. Please sign up again.');
    }
    await cacheUser(cached);
    return cached;
  }

  Future<UserModel> createChildAccount({required String displayName}) async {
    final user = UserModel(
      id: 'child_${_uuid.v4()}',
      email: '',
      displayName: displayName,
      isChildMode: true,
      createdAt: DateTime.now(),
    );
    await cacheUser(user);
    return user;
  }

  /// Small helper used by tests / "forgot password" UX in local mode.
  String generateResetHint() => 'PB-${Random().nextInt(9000) + 1000}';
}
