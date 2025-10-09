import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailcontroller =TextEditingController();
  final TextEditingController passwordcontroller =TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: 
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox( height: 60,),
            Text(
              "TaskOrbit",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
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
           CustomTextFormField(controller: emailcontroller,
           hintText: "Enter email",
           obscureText: false,
           ) ,
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
            const SizedBox(height: 20),
            CustomButton(label: "Login" , onPressed: () {},),
            const SizedBox(height: 50),
            Row(
              children:  [
                SizedBox(width: 35,),
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or"),
                ),
                Expanded(child: Divider(thickness: 1)),
                SizedBox(width: 40,)
              ],
            ),
            SizedBox(height: 35),
            SizedBox(
              width: 420,
              height: 55,
              child: OutlinedButton.icon(
                icon: Icon(FontAwesomeIcons.google, 
                size: 32, color: Colors.black),
                label: Text(
                  "  Continue with Google",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text("Register"),
                )
              ],
            ),
          ],
        ),
      ),
     )
    );
  }
}