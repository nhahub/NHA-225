import 'package:copaw/Feature/Auth/cubit/auth_states.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/provider/user_cubit.dart';
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
  
  void register(BuildContext context) async {
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

        // Update the UserCubit with the new user information
        context.read<UserCubit>().setUser(myUser);
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

  void login(BuildContext context) async {
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

        // Update the UserCubit with the logged-in user's information
        context.read<UserCubit>().setUser(user);
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

  void loginWithGoogle(BuildContext context) async {
  try {
    // Emit loading state
    emit(AuthLoadingState());
    
    // 1. Sign in with Google
    UserCredential userCredential = await AuthService().signInWithGoogle();
    User? user = userCredential.user;

    if (user != null) {
      // 2. Try to get the user from Firestore
      UserModel? existingUser = await AuthService.readUserFromFireStore(user.uid);

      UserModel currentUser;

      if (existingUser == null) {
        // 3. If user does not exist, create a new user in Firestore
        currentUser = UserModel(
          id: user.uid,
          name: user.displayName ?? 'No Name',
          email: user.email ?? 'No Email',
          phone: user.phoneNumber ?? 'No Phone',
        );
        await AuthService.addUserToFirestore(currentUser);
      } else {
        // 4. If user exists, use the existing user data
        currentUser = existingUser;
      }

      // 5. Update the UserCubit to store the current user
      context.read<UserCubit>().setUser(currentUser);

      // 6. Emit success state
      emit(
        AuthSuccessState(
          successMessage: "Google sign-in successful",
          user: user,
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    // Emit error state for Firebase-specific exceptions
    emit(AuthErrorState(errorMessage: e.message ?? "Google sign-in failed."));
  } catch (e) {
    // Emit error state for general exceptions
    emit(AuthErrorState(errorMessage: e.toString()));
  }
}

}
