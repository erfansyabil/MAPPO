import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mappo/components/mybutton.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          emailController.text = data['email'] ?? '';
          usernameController.text = data['username'] ?? '';
          nameController.text = data['name'] ?? '';
          phoneNumberController.text = (data['phone'] != null) ? data['phone'].toString() : '';
          isLoading = false;
        });
      } else  {
        debugPrint('User document does not exist'); 
        setState(() {
          isLoading = false;
          });
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 200),
            const SizedBox(height: 20),
            MyTextField(
              controller: usernameController, 
              hintText: 'Username', 
              obscureText: false, 
              icon: const Icon(Icons.person),
              readOnly: true,
              ),

            const SizedBox(height: 20),
            MyTextField(
              controller: emailController, 
              hintText: 'Email', 
              obscureText: false, 
              icon: const Icon(Icons.email),
              readOnly: true,
              ),

            const SizedBox(height: 20),
            MyTextField(
              controller: nameController, 
              hintText: 'Name', 
              obscureText: false, 
              icon: const Icon(Icons.person),
              readOnly: true,
              ),

            const SizedBox(height: 20),
              MyTextField(
              controller: phoneNumberController, 
              hintText: 'Phone number', 
              obscureText: false, 
              icon: const Icon(Icons.add_call),
              readOnly: true,
              ),
            const SizedBox(height: 20),
            MyButton(
              onTap: (){
                resetPassword(context);
              }, 
              text: 'Reset password'),
          ],
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    String email = emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email for reset password has been sent'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      print('Failed to send reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to send reset email. Please try again later.'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
