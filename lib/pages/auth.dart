import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/pages/homepage.dart';
import 'package:mappo/pages/login.dart';
import 'package:mappo/pages/homepage_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuthService authService = FirebaseAuthService();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            // User is logged in
            return FutureBuilder<String?>(
              future: authService.getUserRole(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasError) {
                  return const Center(child: Text('Failed to get user role'));
                } else {
                  String? role = roleSnapshot.data;
                  if (role == 'admin') {
                    return const AdminHomePage();
                  } else {
                    return const HomePage();
                  }
                }
              },
            );
          } else {
            // User is not logged in
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password and assign role
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Assign role and add user details
      await addUserDetails(
        credential.user!.uid,
        email, // Use email as a placeholder for name
        email.split('@')[0], // Use part of email as a placeholder for username
        email,
        0, // Use 0 as a placeholder for phone
        role,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      debugPrint("An unexpected error occurred: $e");
      return null;
    }
  }

  // Add user details
  Future<void> addUserDetails(String uid, String name, String username,
      String email, int phone, String role) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
    });
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      debugPrint("An unexpected error occurred: $e");
      return null;
    }
  }

  // Get current user role
  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc['role'] as String?;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        debugPrint('The email address is already in use by another account.');
        break;
      case 'invalid-email':
        debugPrint('The email address is not valid.');
        break;
      case 'operation-not-allowed':
        debugPrint('Email/password accounts are not enabled.');
        break;
      case 'weak-password':
        debugPrint('The password is not strong enough.');
        break;
      default:
        debugPrint('An undefined Error happened.');
    }
  }
}
