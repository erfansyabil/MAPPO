import 'package:flutter/material.dart';
import 'package:mappo/pages/auth.dart';
import 'package:mappo/pages/homepage.dart';
import 'package:mappo/pages/homepage_admin.dart';
import 'package:mappo/pages/my_reviews.dart';
import 'pages/signup.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAPPO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const AuthPage(),
      routes: {
        '/signup': (context) =>
            const SignUpPage(), // Define the '/signup' route
        '/home': (context) => const HomePage(),
        '/home_admin': (context) => const AdminHomePage(),
        '/my_review': (context) => const MyReviewsPage(),
        // Add other routes if needed
      },
    );
  }
}
