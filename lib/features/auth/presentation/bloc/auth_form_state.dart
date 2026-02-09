part of 'auth_form_bloc.dart';

class AuthFormState extends Equatable {
  final String name;
  final String email;
  final String password;
  final bool isSignUp;
  final bool autoValidate;
  final bool isValid;

  const AuthFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isSignUp = false,
    this.autoValidate = false,
    this.isValid = false,
  });

  AuthFormState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isSignUp,
    bool? autoValidate,
    bool? isValid,
  }) {
    return AuthFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isSignUp: isSignUp ?? this.isSignUp,
      autoValidate: autoValidate ?? this.autoValidate,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [name, email, password, isSignUp, autoValidate, isValid];
}
