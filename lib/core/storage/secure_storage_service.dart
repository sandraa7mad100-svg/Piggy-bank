import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../constants/hive_boxes.dart';
import '../utils/app_logger.dart';

/// Wraps [FlutterSecureStorage] so auth tokens and any other sensitive
/// values are, by default, the *only* things ever written to platform
/// Keychain/Keystore — never to Hive or SharedPreferences in plaintext.
///
/// On Flutter Web, the plugin depends on the browser's WebCrypto/IndexedDB
/// backend, which can throw a bare JS `Error` in some browser/embedding
/// setups (this is what happens when running the app itself, not something
/// specific to any one call site). Rather than let that take down sign-up/
/// sign-in entirely, every operation here falls back to a local Hive box —
/// logged loudly so it's visible during development — so the app degrades
/// instead of breaking. Mobile (where the plugin is reliable) never hits
/// this path.
class SecureStorageService {
  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  final FlutterSecureStorage _storage;
  static const _fallbackKeyPrefix = 'secure_fallback_';

  Box get _fallbackBox => Hive.box(HiveBoxes.appSettings);

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, st) {
      appLogger.w(
        'Secure storage write failed for "$key" — falling back to local storage. '
        'This value is not hardware-encrypted until the underlying issue is fixed.',
        error: e,
        stackTrace: st,
      );
      await _fallbackBox.put('$_fallbackKeyPrefix$key', value);
    }
  }

  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) return value;
    } catch (e, st) {
      appLogger.w('Secure storage read failed for "$key" — checking local fallback.', error: e, stackTrace: st);
    }
    return _fallbackBox.get('$_fallbackKeyPrefix$key') as String?;
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, st) {
      appLogger.w('Secure storage delete failed for "$key".', error: e, stackTrace: st);
    }
    await _fallbackBox.delete('$_fallbackKeyPrefix$key');
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, st) {
      appLogger.w('Secure storage deleteAll failed.', error: e, stackTrace: st);
    }
    final fallbackKeys = _fallbackBox.keys.where((k) => k.toString().startsWith(_fallbackKeyPrefix)).toList();
    await _fallbackBox.deleteAll(fallbackKeys);
  }
}
