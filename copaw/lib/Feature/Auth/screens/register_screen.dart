import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/Auth/bloc/auth_bloc.dart';
import 'package:copaw/Feature/Auth/bloc/auth_event.dart';
import 'package:copaw/Feature/Auth/bloc/auth_state.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Create Your Account",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: nameController,
                      hintText: "Full name",
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: "email@example.com",
                      validator: (v) =>
                          v!.contains('@') ? null : "Invalid email",
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      validator: (v) => v!.length < 8
                          ? "Password must be at least 8 chars"
                          : null,
                    ),
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                      validator: (v) => v != passwordController.text
                          ? "Passwords don’t match"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            label: "Register",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(RegisterUserEvent(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      username: nameController.text.trim(),
                                    ));
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text("Sign in with Google"),
                      onPressed: () {
                        context.read<AuthBloc>().add(GoogleSignInEvent());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
