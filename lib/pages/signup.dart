import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/components/button.dart';
import 'package:mappo/components/myTextField.dart';
import 'VerifyEmailPage.dart'; // Import the VerifyEmailPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isEmailValid = true;
  bool _doPasswordsMatch = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/images/mappo.png',
                  height: 150,
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  icon: const Icon(Icons.person),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  icon: const Icon(Icons.email),
                ),
                if (!_isEmailValid)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Please enter a valid email address',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  icon: const Icon(Icons.lock),
                ),const SizedBox(height: 20),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  icon: const Icon(Icons.lock),
                  onChanged: (value) {
                    setState(() {
                      _doPasswordsMatch = passwordController.text == confirmPasswordController.text;
                    });
                  },
                ),
                if (!_doPasswordsMatch)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Passwords do not match',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                MyButton(
                  text: "Sign Up",
                  onTap: _isEmailValid ? _signup : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to login page
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      // Navigate to VerifyEmailPage after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(user: userCredential.user),
        ),
      );
    } catch (e) {
      print('Error signing up: $e');
      // Handle sign-up error, e.g., display an error message to the user
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
