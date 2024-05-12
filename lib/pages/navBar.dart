import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/pages/profile.dart'; // Import your profile.dart file

class navBar extends StatelessWidget {
  navBar({Key? key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Name'),
            accountEmail: Text('Welcome ${user?.email ?? 'User'}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                user?.photoURL ??
                    'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
              ),
            ),
            decoration: BoxDecoration(
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
              // Handle home navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('My Reviews'),
            onTap: () {
              // Handle my reviews navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: signUserOut,
          ),
        ],
      ),
    );
  }
}
