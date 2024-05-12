import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class navBar extends StatelessWidget {
  navBar({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Name'),
            accountEmail: Text('Welcome ${user.email!}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('My Reviews'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
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