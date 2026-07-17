import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/error/failures.dart';
import 'package:piggy_bank/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Success reports isSuccess and exposes data', () {
      const result = Result<int>.success(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('Error reports isFailure and exposes the failure', () {
      const failure = ServerFailure('boom');
      const result = Result<int>.failure(failure);
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('when() dispatches to the matching branch', () {
      const success = Result<String>.success('ok');
      const failure = Result<String>.failure(NetworkFailure('offline'));

      expect(
        success.when(success: (d) => 'got:$d', failure: (f) => 'err:${f.message}'),
        'got:ok',
      );
      expect(
        failure.when(success: (d) => 'got:$d', failure: (f) => 'err:${f.message}'),
        'err:offline',
      );
    });
  });
}
