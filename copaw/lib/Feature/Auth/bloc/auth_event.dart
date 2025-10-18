import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  RegisterUserEvent({
    required this.email,
    required this.password,
    required this.username,
  });
}

class GoogleSignInEvent extends AuthEvent {}
