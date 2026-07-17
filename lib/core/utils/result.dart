import '../error/failures.dart';

/// A minimal `Either`-style result type so repositories can return
/// success/failure without throwing across layers, and without pulling in
/// a full functional-programming package for one type.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is Error<T>) return failure(self.failure);
    throw StateError('Unreachable');
  }

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  Failure? get failureOrNull => this is Error<T> ? (this as Error<T>).failure : null;
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}
