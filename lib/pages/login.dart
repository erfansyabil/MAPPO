import 'package:flutter/material.dart';
import 'package:mappo/components/button.dart';
import 'package:mappo/components/myTextField.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(){

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 203, 255, 168),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
               SizedBox(height: 50),

               Icon(
                Icons.lock,
                size: 100,
               ),

               SizedBox(height: 50),

               Text(
                'Login/Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
               ),

               SizedBox(height: 25),

               MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
               ),

               SizedBox(height: 10),

               MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
               ),

               SizedBox(height: 10),

               Padding(
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

               SizedBox(height: 25),

               MyButton(onTap: signIn
               ),
            ],),),)
    );
  }
}