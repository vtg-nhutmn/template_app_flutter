import 'package:demo/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.validateUsername', () {
    test('returns error when value is null', () {
      expect(Validators.validateUsername(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validateUsername(''), isNotNull);
    });

    test('returns error when value is only whitespace', () {
      expect(Validators.validateUsername('  '), isNotNull);
    });

    test('returns error when trimmed length < 3', () {
      expect(Validators.validateUsername('ab'), isNotNull);
    });

    test('returns null when value is exactly 3 characters', () {
      expect(Validators.validateUsername('abc'), isNull);
    });

    test('returns null when value is longer than 3 characters', () {
      expect(Validators.validateUsername('username'), isNull);
    });

    test(
      'returns null when value has leading/trailing spaces but trimmed length >= 3',
      () {
        expect(Validators.validateUsername(' abc '), isNull);
      },
    );
  });

  group('Validators.validatePassword', () {
    test('returns error when value is null', () {
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validatePassword(''), isNotNull);
    });

    test('returns error when length < 6', () {
      expect(Validators.validatePassword('12345'), isNotNull);
    });

    test('returns null when length is exactly 6', () {
      expect(Validators.validatePassword('123456'), isNull);
    });

    test('returns null when length > 6', () {
      expect(Validators.validatePassword('securepassword'), isNull);
    });
  });

  group('Validators.validateEmail', () {
    test('returns error when value is null', () {
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('returns error when value is only whitespace', () {
      expect(Validators.validateEmail('   '), isNotNull);
    });

    test('returns error for invalid format (no @)', () {
      expect(Validators.validateEmail('invalidemail.com'), isNotNull);
    });

    test('returns error for invalid format (no domain)', () {
      expect(Validators.validateEmail('test@'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.validateEmail('test@example.com'), isNull);
    });

    test('returns null for valid email with subdomain', () {
      expect(Validators.validateEmail('user.name+tag@sub.domain.org'), isNull);
    });
  });
  group('Validators.validateFullName', () {
    test('returns error when value is null', () {
      expect(Validators.validateFullName(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validateFullName(''), isNotNull);
    });

    test('returns error when value is only whitespace', () {
      expect(Validators.validateFullName(' '), isNotNull);
    });

    test('returns error when trimmed length < 2', () {
      expect(Validators.validateFullName('A'), isNotNull);
    });

    test('returns null when trimmed length is exactly 2', () {
      expect(Validators.validateFullName('AB'), isNull);
    });

    test('returns null for a normal full name', () {
      expect(Validators.validateFullName('Nguyen Van A'), isNull);
    });
  });
  group('Validators.validatePhone', () {
    test('returns error when value is null', () {
      expect(Validators.validatePhone(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validatePhone(''), isNotNull);
    });

    test('returns error when value is only whitespace', () {
      expect(Validators.validatePhone('   '), isNotNull);
    });

    test('returns error for invalid format (starts with 02x)', () {
      expect(Validators.validatePhone('0201234567'), isNotNull);
    });

    test('returns error for too short number', () {
      expect(Validators.validatePhone('090123456'), isNotNull);
    });

    test('returns error for too long number', () {
      expect(Validators.validatePhone('09012345678'), isNotNull);
    });

    test('returns error for number with letters', () {
      expect(Validators.validatePhone('090abc4567'), isNotNull);
    });

    test('returns null for valid 03x number', () {
      expect(Validators.validatePhone('0301234567'), isNull);
    });

    test('returns null for valid 07x number', () {
      expect(Validators.validatePhone('0701234567'), isNull);
    });

    test('returns null for valid 08x number', () {
      expect(Validators.validatePhone('0861234567'), isNull);
    });

    test('returns null for valid 09x number', () {
      expect(Validators.validatePhone('0901234567'), isNull);
    });
  });
  group('Validators.validateConfirmPassword', () {
    const password = 'mypassword';
    final validator = Validators.validateConfirmPassword(password);

    test('returns error when confirm value is null', () {
      expect(validator(null), isNotNull);
    });

    test('returns error when confirm value is empty', () {
      expect(validator(''), isNotNull);
    });

    test('returns error when confirm value does not match', () {
      expect(validator('differentpassword'), isNotNull);
    });

    test('returns null when confirm value matches exactly', () {
      expect(validator(password), isNull);
    });
  });
}
