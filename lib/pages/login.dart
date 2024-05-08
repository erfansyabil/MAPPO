import 'package:flutter/material.dart';
import 'package:mappo/components/button.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/components/squareTile.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(){

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 255, 216),
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
                'Login/Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
               ),

               const SizedBox(height: 25),

               MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
               ),

               const SizedBox(height: 10),

               MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
               ),

               const SizedBox(height: 10),

               const Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 25),
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

               const SizedBox(height: 25),

               MyButton(onTap: signIn
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
                        Expanded
                        (child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 100, 100, 100),
                        )
                        )
                        ],
                 ),
              ),

              const SizedBox(height: 50),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/google.png'),
                  SizedBox(width: 20,),
                  SquareTile(imagePath: 'lib/images/apple.png'),
                ],
              ),
            ],),),)
    );
  }
}