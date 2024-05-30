import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/components/mybutton.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/components/myDropdown.dart';
import 'verify_email.dart';
import 'auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isEmailValid = true;
  bool _doPasswordsMatch = true;
  bool _isLoading = false;
  String _selectedRole = 'customer'; // Default role

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() {
        _isEmailValid = false;
        _isLoading = false;
      });
      return;
    } else {
      setState(() {
        _isEmailValid = true;
      });
    }

    if (password != confirmPassword) {
      setState(() {
        _doPasswordsMatch = false;
        _isLoading = false;
      });
      return;
    } else {
      setState(() {
        _doPasswordsMatch = true;
      });
    }

    User? user = await _authService.signUpWithEmailAndPassword(
      email,
      password,
      _selectedRole,
    );

    if (user != null) {
      await _authService.addUserDetails(
        user.uid,
        name,
        username,
        email,
        int.parse(phone),
        _selectedRole,
      );

      await user.sendEmailVerification();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(user: user),
        ),
      );
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up')),
      );
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/img/mappo.png',
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        icon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 20),
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
                      ),
                      const SizedBox(height: 20),
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
                      MyTextField(
                        controller: phoneController,
                        hintText: 'Phone Number',
                        obscureText: false,
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(height: 20),
                      MyDropdown(
                        hintText: 'Select Role',
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const ['customer', 'admin'],
                        value: _selectedRole.isEmpty ? 'customer' : _selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        text: "Sign Up",
                        onTap: _signup,
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
}
