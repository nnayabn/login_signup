import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <- important
import 'login_screen.dart';     // <- your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- using your options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Home screen logic, this can be replaced with a future check or a route.
      home: const LoginScreen(),
      // You can set up routes if needed for better navigation management
      routes: {
        '/login': (context) => const LoginScreen(),
        // Add any other routes for your app screens here
      },
    );
  }
}

