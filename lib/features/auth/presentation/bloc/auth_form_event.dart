part of 'auth_form_bloc.dart';

abstract class AuthFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormFieldChanged extends AuthFormEvent {
  final String? name;
  final String? email;
  final String? password;

  FormFieldChanged({this.name, this.email, this.password});

  @override
  List<Object?> get props => [name, email, password];
}

class FormModeToggled extends AuthFormEvent {}
