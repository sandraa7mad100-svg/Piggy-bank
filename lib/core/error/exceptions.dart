/// Low-level exceptions thrown by data sources (Firebase, Dio, Hive).
/// Repositories catch these and map them to a [Failure].
class ServerException implements Exception {
  const ServerException([this.message = 'Server error']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No network connection']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'Authentication error']);
  final String message;
}

class AiException implements Exception {
  const AiException([this.message = 'AI provider error']);
  final String message;
}
