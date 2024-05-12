import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mappo/pages/homepage.dart';
import 'package:mappo/pages/login.dart';


class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 255, 216),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot){
          //user is logged in
          if(snapshot.hasData){
            return const HomePage();
          }

          //usr not logged in
          else{
            return const LoginPage();
          }
        }
        ),
    );
  }
}

class FirebaseAuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email,String password) async{

    try{
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
          return credential.user;
    }catch(e){
      print("Some error occured");
    }
    return null;

  }
}