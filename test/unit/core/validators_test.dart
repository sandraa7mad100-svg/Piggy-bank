import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    final validate = Validators.email();

    test('accepts a valid email', () {
      expect(validate('kid@example.com'), isNull);
    });

    test('rejects an invalid email', () {
      expect(validate('not-an-email'), isNotNull);
    });
  });

  group('Validators.password', () {
    final validate = Validators.password();

    test('accepts a password with 8+ chars and a number', () {
      expect(validate('secret123'), isNull);
    });

    test('rejects a password shorter than 8 characters', () {
      expect(validate('abc123'), isNotNull);
    });

    test('rejects a password with no digits', () {
      expect(validate('abcdefgh'), isNotNull);
    });
  });

  group('Validators.amount', () {
    final validate = Validators.amount();

    test('accepts a positive number', () {
      expect(validate('12.50'), isNull);
    });

    test('rejects zero', () {
      expect(validate('0'), isNotNull);
    });

    test('rejects negative numbers', () {
      expect(validate('-5'), isNotNull);
    });

    test('rejects non-numeric input', () {
      expect(validate('abc'), isNotNull);
    });

    test('rejects empty input', () {
      expect(validate(''), isNotNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('passes when it matches the original', () {
      final validate = Validators.confirmPassword(() => 'secret123');
      expect(validate('secret123'), isNull);
    });

    test('fails when it does not match the original', () {
      final validate = Validators.confirmPassword(() => 'secret123');
      expect(validate('different'), isNotNull);
    });
  });
}
