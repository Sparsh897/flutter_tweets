part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthenticationEvent extends AuthEvent {
  final AuthType authtype;
  final String email;
  final String password;

  AuthenticationEvent(
      {required this.authtype, required this.email, required this.password});
}
