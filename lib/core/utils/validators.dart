import 'package:form_validator/form_validator.dart';

/// Reusable field validators built on `form_validator`'s [ValidationBuilder]
/// so every form in the app validates emails/passwords/names the same way.
abstract final class Validators {
  static String? Function(String?) email() => ValidationBuilder()
      .email('Enter a valid email address')
      .maxLength(120)
      .build();

  static String? Function(String?) password() => ValidationBuilder()
      .minLength(8, 'Password must be at least 8 characters')
      .regExp(
        RegExp(r'(?=.*[0-9])'),
        'Password must contain at least one number',
      )
      .build();

  static String? Function(String?) confirmPassword(String Function() original) =>
      ValidationBuilder().add((value) {
        if (value != original()) return "Passwords don't match";
        return null;
      }).build();

  static String? Function(String?) displayName() =>
      ValidationBuilder().minLength(2, 'Name is too short').maxLength(40).build();

  static String? Function(String?) required([String message = 'This field is required']) =>
      ValidationBuilder().required(message).build();

  static String? Function(String?) amount() => ValidationBuilder().add((value) {
        if (value == null || value.trim().isEmpty) return 'Enter an amount';
        final parsed = double.tryParse(value.trim());
        if (parsed == null) return 'Enter a valid number';
        if (parsed <= 0) return 'Amount must be greater than zero';
        return null;
      }).build();
}
