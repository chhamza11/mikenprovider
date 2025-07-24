import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return PasswordValidationError.empty;
    } else if ((value?.length ?? 0) < 8) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Please enter a password';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters';
      default:
        return null;
    }
  }
}
