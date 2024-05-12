import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mappo/components/button.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/components/squareTile.dart';
import 'package:mappo/pages/ForgotPassword.dart';
import 'signup_page.dart'; // Import your sign-up page file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator()
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
        );

        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context).pop();

        } on FirebaseAuthException catch (e) {
          
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          Navigator.of(context).pop();

          if (e.code == 'user-not-found'){
            wrongEmailMessage();
            } else if (e.code == 'wrong-password'){
              wrongPasswordMessage();
              }
        }
      }

      void wrongEmailMessage(){
        showDialog(
          context: context, 
          builder: (context){
            return const AlertDialog(
              title: Text('Incorrect Email',),
              );
          }
          );
      }

      void wrongPasswordMessage(){
        showDialog(
          context: context, 
          builder: (context){
            return const AlertDialog(
              title: Text('Incorrect Password',),
              );
          }
          );
      }

  void signInWithGoogle(BuildContext context) {
    // Add logic to sign in with Google
    print("Signing in with Google...");
  }

  void signInWithApple(BuildContext context) {
    // Add logic to sign in with Apple
    print("Signing in with Apple...");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signup': (context) => SignUpPage(), // Define the '/signup' route
      },
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 174, 255, 216),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
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
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
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
                const SizedBox(height: 25),
                MyButton(onTap: signIn),
                const SizedBox(height: 0),
                TextButton(
                  onPressed: () {
                    // Navigate to sign up page
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Don't have an account? Create one",
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 100, 100),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'Or continue with',
                            style: TextStyle(color: Color.fromARGB(255, 100, 100, 100))),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 100, 100, 100),
                          )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        signInWithGoogle(context);
                      },
                      child: const SquareTile(imagePath: 'lib/images/google.png'),
                    ),
                    const SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        signInWithApple(context);
                      },
                      child: const SquareTile(imagePath: 'lib/images/apple.png'),
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
