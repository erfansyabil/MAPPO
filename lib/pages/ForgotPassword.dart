import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPassword({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 255, 216),
      appBar: AppBar(
        title: const Text('Forgot Password?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/images/forget.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetPassword(context);
              },
              child: const Text('Reset Password'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    String email = emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset email sent!'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      print('Failed to send reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send reset email. Please try again later.'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
