import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mappo/components/button.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/pages/forgotpassword.dart';
import 'signup.dart'; // Import your sign-up page file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isEmailValid = true;

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

    if (!mounted) return;

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
        
        Navigator.of(context).pop();
         if (!mounted) return;

        } on FirebaseAuthException catch (e) {
          
          Navigator.of(context).pop();

           if (!mounted) return;

          if (e.code == 'invalid-email'){
            wrongEmailMessage();
            } else if (e.code == 'invalid-credential'){
              wrongPasswordMessage();
              }
        }
      }

      void wrongEmailMessage(){
         if (!mounted) return;
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
         if (!mounted) return;
        showDialog(
          context: context, 
          builder: (context){
            return const AlertDialog(
              title: Text('Incorrect Password'),
              );
          }
          );
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'lib/images/mappo.png',
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
                    const SizedBox(height: 20),
                    MyButton(
                      text: "Sign In",
                      onTap: signIn,
                    ),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
