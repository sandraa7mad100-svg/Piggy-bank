import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures. Repositories translate thrown
/// [Exception]s into a [Failure] so the presentation layer never has to
/// catch raw exceptions from Firebase/Dio/Hive.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "You're offline. Some things may be out of date."]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AiFailure extends Failure {
  const AiFailure([super.message = "The assistant couldn't respond right now."]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = "We couldn't find that."]);
}
