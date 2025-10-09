import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});

  final TextEditingController emailcontroller =TextEditingController();
  final TextEditingController passwordcontroller =TextEditingController();
  final TextEditingController namecontroller =TextEditingController();
  final TextEditingController confirmpasswordcontroller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Create Your Account",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
        Align(
           alignment: Alignment.centerLeft,
               child: Padding(
              padding: EdgeInsets.only(left: 36, bottom: 5), 
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
            controller: namecontroller ,
            hintText: "Enter your full name", 
            obscureText: false),
            Align(
           alignment: Alignment.centerLeft,
               child: Padding(
              padding: EdgeInsets.only(left: 36, bottom: 5), 
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
            controller: emailcontroller ,
            hintText: "email@example.com", 
            obscureText: false),
           Align(
           alignment: Alignment.centerLeft,
               child: Padding(
              padding: EdgeInsets.only(left: 36, bottom: 5), 
             child: Text(
                "Pasword",
                  style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
              ),
            CustomTextFormField(
            controller: passwordcontroller ,
            hintText: "Enter password", 
            obscureText: true),
           Align(
           alignment: Alignment.centerLeft,
               child: Padding(
              padding: EdgeInsets.only(left: 36, bottom: 5), 
             child: Text(
                "Confirm pasword",
                  style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
              ),
            CustomTextFormField(
            controller: confirmpasswordcontroller ,
            hintText: "Re-enter password", 
            obscureText: true),
            const SizedBox(height: 20),
            CustomButton(
              label: "Register",
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(

                  onPressed: () {},
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}