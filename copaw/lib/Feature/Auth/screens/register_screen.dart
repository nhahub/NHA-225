import 'package:copaw/Feature/Auth/cubit/auth_states.dart';
import 'package:copaw/Feature/Auth/cubit/auth_view_model.dart';
import 'package:copaw/Feature/Auth/screens/login_screen.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:copaw/utils/app_validator.dart';
import 'package:copaw/utils/dialog_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthStates>(
      bloc: authViewModel,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          DialogUtils.showLoading(
            context: context,
            loadingText: "Registering...",
          );
        } else if (state is AuthSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage ?? "Registration successful",
            title: "Success",
            posActionName: "OK",
            posAction: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
          );
        } else if (state is AuthErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.errorMessage,
            title: "Registration Error",
            posActionName: "OK",
            posAction: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: authViewModel.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Your Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, bottom: 5),
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: authViewModel.nameController,
                    hintText: "Enter your full name",
                    obscureText: false,
                    validator: (value) =>
                        AppValidators.nameValidator(value, context),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, bottom: 5),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: authViewModel.emailController,
                    hintText: "email@example.com",
                    obscureText: false,
                    validator: (value) =>
                        AppValidators.emailValidator(value, context),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, bottom: 5),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: authViewModel.passwordController,
                    hintText: "Enter password",
                    obscureText: true,
                    validator: (value) =>
                        AppValidators.passwordValidator(value, context),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, bottom: 5),
                      child: Text(
                        "Confirm password",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: authViewModel.confirmPasswordController,
                    hintText: "Re-enter password",
                    obscureText: true,
                    validator: (value) =>
                        AppValidators.confirmPasswordValidator(
                          value,
                          authViewModel.passwordController.text,
                          context,
                        ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 36, bottom: 5),
                      child: Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: authViewModel.phoneController,
                    hintText: "Enter your phone number",
                    keyBoardType: TextInputType.phone,
                    validator: (value) =>
                        AppValidators.phoneValidator(value, context),
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    label: "Register",
                    onPressed: () => authViewModel.register(),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.google),
                      label: const Text(
                        "SignIn with Google",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onPressed: () => authViewModel.loginWithGoogle(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
