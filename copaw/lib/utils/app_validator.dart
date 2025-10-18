import 'package:flutter/material.dart';

class AppValidators {
  static String? nameValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return "please enter your name";
    }
    return null;
  }
  static String? emailValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return "please enter your email";
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);
    if (!emailValid) {
      return "please enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return "Please enter your password";
    }
    // Check minimum length
    if (text.length < 8) {
      return "Please enter at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return "Please include at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
      return "Please include at least one special character";
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? rePassword,
    String? password,
    BuildContext context,
  ) {
    if (rePassword == null || rePassword.isEmpty) {
      return "Please confirm your password";
    }
    // Check minimum length
    if (rePassword.length < 8) {
      return "Please enter at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(rePassword)) {
      return "Please include at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(rePassword)) {
      return "Please include at least one special character";
    }
    // Check if it matches the original password
    if (password != rePassword) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? phoneValidator(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return "Please enter your phone number";
    }
    return null;
  }
}
