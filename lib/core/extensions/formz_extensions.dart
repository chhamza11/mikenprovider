import 'package:formz/formz.dart';

extension FormzInputExtension<T, E> on FormzInput<T, E> {
  bool get invalid => !isValid && error != null;
}
