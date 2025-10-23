import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthErrorState extends AuthStates {
  String errorMessage;
  AuthErrorState({required this.errorMessage});
}

class AuthSuccessState extends AuthStates {
  User? user;
  String? successMessage;
  
  AuthSuccessState({this.successMessage, this.user});
}