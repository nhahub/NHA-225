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

        final firebaseUser = credential.user;
        if (firebaseUser == null) {
          await FirebaseAuth.instance.signOut();
          emit(
            AuthErrorState(
              errorMessage:
                  "Login failed. Please try again or contact support if the issue persists.",
            ),
          );
          return;
        }

        var user = await AuthService.readUserFromFireStore(firebaseUser.uid);
        if (user == null) {
          await FirebaseAuth.instance.signOut();
          emit(
            AuthErrorState(
              errorMessage:
                  "We couldn't find your profile data. Please register again.",
            ),
          );
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
    emit(AuthLoadingState());

    try {
      // 1️⃣ Prompt user to select a Google account
      UserCredential userCredential = await AuthService().signInWithGoogle();
      User? firebaseUser = userCredential.user;
      // Safety: if sign-in was canceled
      if (firebaseUser == null) {
        emit(
          AuthErrorState(
            errorMessage: "Google sign-in was canceled or failed.",
          ),
        );
        return;
      }

      // 2️⃣ Check Firestore for registered app user
      UserModel? existingUser = await AuthService.readUserFromFireStore(
        firebaseUser.uid,
      );

      if (existingUser == null) {
        // Not registered in Firestore → block login
        await FirebaseAuth.instance.signOut(); // remove auth session
        emit(
          AuthErrorState(
            errorMessage:
                "This Google account is not registered yet. Please register first.",
          ),
        );
        print("USER ISSSS____________________________ :   $existingUser");
        print("CURRENT STATE AFTER EMIT: ${state.runtimeType}");
        return;
      }

      // 3️⃣ Firestore user exists → login success
      context.read<UserCubit>().setUser(existingUser);
      emit(
        AuthSuccessState(
          successMessage: "Google login successful",
          user: firebaseUser,
        ),
      );
    } catch (e) {
      // Any unexpected errors → ensure user is signed out and emit error
      await FirebaseAuth.instance.signOut();
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void registerWithGoogle(BuildContext context) async {
    try {
      emit(AuthLoadingState());

      UserCredential userCredential = await AuthService().signInWithGoogle();
      User? user = userCredential.user;

      if (user != null) {
        // Check if this Google account is already registered
        UserModel? existingUser = await AuthService.readUserFromFireStore(
          user.uid,
        );

        if (existingUser != null) {
          // User already exists → cannot register twice
          await FirebaseAuth.instance.signOut();

          emit(
            AuthErrorState(
              errorMessage:
                  "This Google account is already registered. Please login instead.",
            ),
          );
          return;
        }

        // Create the new user
        UserModel newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? 'No Name',
          email: user.email ?? 'No Email',
          phone: user.phoneNumber ?? 'No Phone',
          avatarUrl: user.photoURL,
        );

        await AuthService.addUserToFirestore(newUser);
        context.read<UserCubit>().setUser(newUser);

        emit(
          AuthSuccessState(
            successMessage: "Google registration successful",
            user: user,
          ),
        );
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
}
