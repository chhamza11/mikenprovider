import 'package:formz/formz.dart';

enum NameValidationError { empty, tooShort }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return NameValidationError.empty;
    } else if ((value?.trim().length ?? 0) < 2) {
      return NameValidationError.tooShort;
    }
    return null;
  }

  String? get errorMessage {
    switch (error) {
      case NameValidationError.empty:
        return 'Please enter your name';
      case NameValidationError.tooShort:
        return 'Name must be at least 2 characters';
      default:
        return null;
    }
  }
}
