// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/components/mybutton.dart';
import 'package:mappo/components/myTextField.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Forgot Password?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.lock_outline_rounded,
              size: 200,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              icon: const Icon(Icons.email),
            ),
            const SizedBox(height: 20),
            MyButton(
                onTap: () {
                  resetPassword(context);
                },
                text: 'Reset Password'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

void resetPassword(BuildContext context) async {
  String email = emailController.text;

  if (!mounted) {
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password reset email sent!'),
      duration: Duration(seconds: 3),
    ));
  } catch (e) {
    debugPrint('Failed to send reset email: $e');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to send reset email. Please try again later.'),
      duration: Duration(seconds: 3),
    ));
  }
}

}
