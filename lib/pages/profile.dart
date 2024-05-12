import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ProfilePage() {
    User? user = FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? '';
    //usernameController.text = user?.username ?? '';
    //passwordController.text = user?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/images/user.jpeg',
              height: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline_outlined),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'phone number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.add_call),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.remove_red_eye),
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
        content: Text('Edit Profile'),
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
