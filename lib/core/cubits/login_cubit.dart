import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../repositories/auth_repository.dart';
import '../models/email.dart';
import '../models/password.dart';
import '../enums/form_status.dart';

class LoginState {
  final Email email;
  final Password password;
  final FormStatus status;
  final String? errorMessage;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormStatus.pure,
    this.errorMessage,
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    FormStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    final isValid = Formz.validate([email, state.password]);
    emit(state.copyWith(
      email: email,
      status: isValid ? FormStatus.valid : FormStatus.invalid,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final isValid = Formz.validate([state.email, password]);
    emit(state.copyWith(
      password: password,
      status: isValid ? FormStatus.valid : FormStatus.invalid,
    ));
  }

  Future<void> login() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormStatus.submissionInProgress));
    try {
      await _authRepository.signIn(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormStatus.submissionSuccess));
    } catch (error) {
      emit(state.copyWith(
        status: FormStatus.submissionFailure,
        errorMessage: error.toString(),
      ));
    }
  }
}
