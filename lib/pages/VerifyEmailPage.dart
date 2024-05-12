import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatelessWidget {
  final User? user;

  const VerifyEmailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'A verification email has been sent to ${user!.email}. Please check your inbox and click the verification link to complete the registration process.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendEmailVerification(context);
              },
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEmailVerification(BuildContext context) async {
    try {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email resent.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error sending verification email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend verification email. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
