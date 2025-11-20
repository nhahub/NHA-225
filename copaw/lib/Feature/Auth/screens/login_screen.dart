import 'package:copaw/Feature/Auth/cubit/auth_states.dart';
import 'package:copaw/Feature/Auth/cubit/auth_view_model.dart';
import 'package:copaw/Feature/Auth/screens/register_screen.dart';
import 'package:copaw/Feature/Home/screens/Home_screen.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/provider/user_cubit.dart';
import 'package:copaw/utils/app_validator.dart';
import 'package:copaw/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, this.initialMessage});

  final String? initialMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = widget.initialMessage;
      if (message != null && mounted) {
        DialogUtils.hideLoadingIfVisible(context: context);
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: "Register",
              onPressed: () {
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                );
              },
            ),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthStates>(
      bloc: authViewModel,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          DialogUtils.showLoading(
            context: context,
            loadingText: "logging in...",
          );
        } else if (state is AuthSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage ?? "Login successful",
            title: "Success",
            posActionName: "OK",
            posAction: () {
              final currentUser = context.read<UserCubit>().state;
              if (currentUser != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(user: currentUser),
                  ),
                  (route) => false,
                );
              }
            },
          );
        } else if (state is AuthErrorState) {
          DialogUtils.hideLoading(context: context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            DialogUtils.showMessage(
              context: context,
              message: state.errorMessage,
              posActionName: "OK",
              posAction: () => Navigator.pop(context),
            );
          });
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: authViewModel.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    "Copaw",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),

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

                  const SizedBox(height: 20),

                  CustomButton(
                    label: "Login",
                    onPressed: () => authViewModel.login(context),
                  ),

                  const SizedBox(height: 50),

                  Row(
                    children: const [
                      SizedBox(width: 35),
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("or"),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                      SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 55,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        size: 32,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "  Continue with Google",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async =>
                          authViewModel.loginWithGoogle(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Register"),
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
