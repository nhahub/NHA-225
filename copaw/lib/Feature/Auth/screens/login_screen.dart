import 'package:copaw/Feature/Auth/screens/register_screen.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Services/firebaseServices/authService.dart';
import 'package:copaw/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
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
                    child: const Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                CustomTextFormField(
                  controller: emailcontroller,
                  hintText: "Enter email",
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                  }
                
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36, bottom: 5),
                    child: const Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                CustomTextFormField(
                  controller: passwordcontroller,
                  hintText: "Enter password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                  }
                ),

                const SizedBox(height: 20),

                CustomButton(
                  label: "Login",
                  onPressed: () async {
                     if (_formKey.currentState!.validate()) {
                      try {
                        await AuthService.login(
                          email: emailcontroller.text.trim(),
                          password: passwordcontroller.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Login successful'),
                              ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message = "Login failed.";

                        if (e.code == 'invalid-credential') {
                          message = 'incorrect email or password';
                        } 
                         else if (e.code == 'wrong-password') {
                         message = 'Incorrect password.';
                        } 
                         else if (e.code == 'invalid-email') {
                           message = 'Invalid email address.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                           
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unexpected error occurred.'),
                           
                          ),
                        );
                      }
                    }
                  },
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
                    icon: const Icon(FontAwesomeIcons.google,
                        size: 32, color: Colors.black),
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
                    onPressed: () async {
                      try {
                        await AuthService.signInWithGoogle();
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message = "Google sign-in failed.";
                        if (e.code == 'account-exists-with-different-credential') {
                          message =
                              'Account exists with a different sign-in method.';
                        } else if (e.code == 'invalid-credential') {
                          message = 'Invalid credentials. Try again.';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error occurred while signing in.'),
                          ),
                        );
                      }
                    },
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
                        MaterialPageRoute (builder: (context) => RegisterScreen(),)
                        );
                      },
                      child: const Text("Register"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
