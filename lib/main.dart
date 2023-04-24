import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes/Views/Screens/home_page.dart';
import 'package:firebase_notes/Views/Screens/login_page.dart';
import 'package:firebase_notes/Views/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orangeAccent,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        'login_page': (context) => const LoginPage(),
        'notes_screen': (context) => const NotesScreen(),
      },
    ),
  );
}
