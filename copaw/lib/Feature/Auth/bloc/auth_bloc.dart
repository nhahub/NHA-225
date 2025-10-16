import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Services/firebaseServices/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<GoogleSignInEvent>(_onGoogleSignIn);
  }

  Future<void> _onRegisterUser(
      RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await AuthService.register(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(AuthSuccess(message: 'Account created successfully'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.message ?? "Registration failed"));
    }
  }

  Future<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signInWithGoogle();
      emit(AuthSuccess(message: 'Signed in with Google'));
    } catch (e) {
      emit(AuthFailure(message: "Google sign-in failed"));
    }
  }
}
