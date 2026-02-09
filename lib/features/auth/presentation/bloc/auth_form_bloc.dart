import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc() : super(const AuthFormState()) {
    on<FormFieldChanged>(_onFormFieldChanged);
    on<FormModeToggled>(_onFormModeToggled);
  }

  void _onFormFieldChanged(
    FormFieldChanged event,
    Emitter<AuthFormState> emit,
  ) {
    final name = event.name ?? state.name;
    final email = event.email ?? state.email;
    final password = event.password ?? state.password;

    emit(state.copyWith(
      name: name,
      email: email,
      password: password,
      autoValidate: true,
      isValid: _validateForm(name, email, password, state.isSignUp),
    ));
  }

  void _onFormModeToggled(
    FormModeToggled event,
    Emitter<AuthFormState> emit,
  ) {
    emit(AuthFormState(isSignUp: !state.isSignUp));
  }

  bool _validateForm(String name, String email, String password, bool isSignUp) {
    if (isSignUp && (name.isEmpty || name.length < 3)) return false;
    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) return false;
    if (password.isEmpty || password.length < 6) return false;
    return true;
  }
}
