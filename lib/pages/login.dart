import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mappo/components/mybutton.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/pages/forgotpassword.dart';
import 'signup.dart';
import 'auth.dart';
import 'homepage.dart';
import 'homepage_admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isEmailValid = true;

  FirebaseAuthService authService = FirebaseAuthService();

void signIn() async {
  if (!_validateEmail(emailController.text)) {
    setState(() {
      _isEmailValid = false;
    });
    return;
  } else {
    setState(() {
      _isEmailValid = true;
    });
  }

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    User? user = await authService.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog

    if (user != null) {
      // Fetch user role
      String? role = await authService.getUserRole();

      if (role != null) {
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } else {
        roleInvalid();
      }
    }
    }
  } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog
        _handleFirebaseAuthException(e);
      }
  } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog
        showErrorDialog(e.toString());
      }
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

void _handleFirebaseAuthException(FirebaseAuthException e) {
  if (e.code == 'user-not-found') {
    wrongEmailMessage();
  } else if (e.code == 'wrong-password') {
    debugPrint("Wrong Password");
    wrongPasswordMessage();
  } else if (e.code == 'invalid-email') {
    debugPrint("Wrong Email");
    showErrorDialog('The email address is not valid.');
  } else if (e.code == 'user-disabled') {
    debugPrint("User BANNED");
    showErrorDialog('This user has been disabled.');
  } else if (e.code == 'too-many-requests') {
    debugPrint("Too Many Requests");
    showErrorDialog('Too many requests. Please try again later.');
  } else {
    debugPrint("Unknown Error");
    showErrorDialog(e.message ?? 'An unknown error occurred.');
  }
}

void showErrorDialog(String message) {
    if (mounted) {
      Navigator.of(context).pop(); // Remove loading dialog if still mounted
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


void wrongEmailMessage() {
    if (mounted) {
      Navigator.of(context).pop(); // Remove loading dialog if still mounted
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incorrect/Not exist Email'),
            content: const Text('The email address entered is invalid/not exist.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

void wrongPasswordMessage() {
    if (mounted) {
      Navigator.of(context).pop(); // Remove loading dialog if still mounted
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incorrect Password'),
            content: const Text('The password entered is incorrect.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

void roleInvalid() {
    if (mounted) {
      Navigator.of(context).pop(); // Remove loading dialog if still mounted
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Role Invalid'),
            content: const Text('Your user role is not valid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signup': (context) => const SignUpPage(), // Define the '/signup' route
      },
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/img/mappo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    icon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 100, 100, 100),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Sign In",
                    onTap: signIn,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to sign up page
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Don't have an account? Create one",
                              style: TextStyle(
                                color: Color.fromARGB(255, 100, 100, 100),
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
