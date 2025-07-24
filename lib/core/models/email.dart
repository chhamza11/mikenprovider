import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return EmailValidationError.empty;
    } else if (!_emailRegExp.hasMatch(value ?? '')) {
      return EmailValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    switch (error) {
      case EmailValidationError.empty:
        return 'Please enter an email';
      case EmailValidationError.invalid:
        return 'Please enter a valid email';
      default:
        return null;
    }
  }
}
