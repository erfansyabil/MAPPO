import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
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
          phoneNumberController.text = data['phone'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
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
              hintText: 'Name', 
              obscureText: false, 
              icon: const Icon(Icons.person)
              ),
            /*
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline_outlined),
              ),
            ),*/

            const SizedBox(height: 20),
            MyTextField(
              controller: emailController, 
              hintText: 'Email', 
              obscureText: false, 
              icon: const Icon(Icons.email)
              ),
            /*
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),*/

            const SizedBox(height: 20),
            MyTextField(
              controller: usernameController, 
              hintText: 'Name', 
              obscureText: false, 
              icon: const Icon(Icons.person)
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.add_call),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
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

  //buttons nak tukar fucction laterrrrr
  void resetPassword(BuildContext context) async {
    String email = emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Edit Profile'),
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
