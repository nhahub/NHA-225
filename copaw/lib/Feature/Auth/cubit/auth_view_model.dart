import 'package:copaw/Feature/Auth/cubit/auth_states.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthViewModel extends Cubit<AuthStates> {
  AuthViewModel() : super(AuthInitialState());

  // controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  void register() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(AuthLoadingState());
        // Create user with email and password using FirebaseAuth
        // This will return a UserCredential object containing the user's information
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              // Firebase authentication method for email and password
              email: emailController.text,
              password: passwordController.text,
            );

        // Create a MyUser object with the user's information
        // This object will be used to store user data in Firestore
        UserModel myUser = UserModel(
          id: credential.user!.uid,
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
        );

        // Add the user to Firestore using FirebaseUtils
        await AuthService.addUserToFirestore(myUser);
        emit(AuthSuccessState(successMessage: "Registration successful"));
      }
    } on FirebaseAuthException catch (e) {
      // Show appropriate error messages based on the error code
      // These messages will inform the user about the specific issue that occurred
      if (e.code == 'weak-password') {
        emit(
          AuthErrorState(errorMessage: "The password provided is too weak."),
        );
        // If the email is already in use, show a message to the user
      } else if (e.code == 'email-already-in-use') {
        emit(
          AuthErrorState(
            errorMessage: "The account already exists for that email.",
          ),
        );

        // If there is a network request failure, show a message to the user
      } else if (e.code == 'network-request-failed') {
        emit(
          AuthErrorState(
            errorMessage:
                "Network error occurred. Please check your internet connection and try again.",
          ),
        );
      }

      // Catch any other errors that occur during registration
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void login() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(AuthLoadingState());
        // Sign in with email and password
        // This uses FirebaseAuth to authenticate the user
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              // Firebase authentication method for email and password
              email: emailController.text,
              password: passwordController.text,
            );
        // Check if the credential or user is null
        // If the user is null, it means the login failed
        var user = await AuthService.readUserFromFireStore(
          credential.user?.uid ?? '',
        );
        if (user == null) {
          return;
        }
        emit(AuthSuccessState(successMessage: "Login successful"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        emit(
          AuthErrorState(errorMessage: "The email or password is incorrect."),
        );
      } else if (e.code == 'network-request-failed') {
        emit(
          AuthErrorState(
            errorMessage:
                "Network error occurred. Please check your internet connection and try again.",
          ),
        );
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void loginWithGoogle() async {
    try {
      emit(AuthLoadingState());
      UserCredential userCredential = await AuthService().signInWithGoogle();
      User? user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        UserModel? existingUser = await AuthService.readUserFromFireStore(
          user.uid,
        );

        if (existingUser == null) {
          // If user does not exist, create a new user in Firestore
          UserModel newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email ?? 'No Email',
            phone: user.phoneNumber ?? 'No Phone',
          );
          await AuthService.addUserToFirestore(newUser);
        }

        emit(
          AuthSuccessState(
            successMessage: "Google sign-in successful",
            user: user,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(errorMessage: e.message ?? "Google sign-in failed."));
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
}
