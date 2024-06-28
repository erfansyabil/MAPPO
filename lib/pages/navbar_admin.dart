import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/pages/add_restaurant.dart';
import 'package:mappo/pages/homepage_admin.dart';
import 'package:mappo/pages/my_reviews.dart';
import 'package:mappo/pages/profile.dart'; // Import your profile.dart file
import 'package:mappo/pages/login.dart'; // Import the login page to navigate after logout
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class NavBarAdmin extends StatelessWidget {
  const NavBarAdmin({super.key});

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading username');
        } else {
          String username = snapshot.data?['name'] ?? 'User';
          return Drawer(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Welcome $username'),
                  accountEmail: Text('${user?.email}'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.photoURL ??
                          'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer and navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add a restaurant'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer and navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRestaurantPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rate_review),
                  title: const Text('My Reviews'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer and navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyReviewsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer and navigate
                    // Handle settings navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer and navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () {
                    signUserOut(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
