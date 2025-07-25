import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../repositories/auth_repository.dart';
import '../models/email.dart';
import '../models/password.dart';
import '../models/name.dart';
import '../enums/form_status.dart';

class SignupState {
  final Email email;
  final Password password;
  final Name name;
  final FormStatus status;
  final String? errorMessage;

  SignupState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.status = FormStatus.pure,
    this.errorMessage,
  });

  SignupState copyWith({
    Email? email,
    Password? password,
    Name? name,
    FormStatus? status,
    String? errorMessage,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    final isValid = Formz.validate([email, state.password, state.name]);
    emit(state.copyWith(
      email: email,
      status: isValid ? FormStatus.valid : FormStatus.invalid,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final isValid = Formz.validate([state.email, password, state.name]);
    emit(state.copyWith(
      password: password,
      status: isValid ? FormStatus.valid : FormStatus.invalid,
    ));
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    final isValid = Formz.validate([state.email, state.password, name]);
    emit(state.copyWith(
      name: name,
      status: isValid ? FormStatus.valid : FormStatus.invalid,
    ));
  }

  Future<void> signUp(Function onProfileCompletion) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormStatus.submissionInProgress));
    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
      );
      // No need to call signIn here, session is already active after signup
      emit(state.copyWith(status: FormStatus.submissionSuccess));
      onProfileCompletion();
    } catch (error) {
      emit(state.copyWith(
        status: FormStatus.submissionFailure,
        errorMessage: error.toString(),
      ));
    }
  }
}
