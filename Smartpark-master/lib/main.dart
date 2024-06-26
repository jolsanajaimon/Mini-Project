import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/const.dart';
import 'package:smartpark/login.dart';
import 'package:smartpark/mainparking.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFFF8D73A,
          const <int, Color>{
            50: const Color(0xFFF8D73A),
            100: const Color(0xFFF8D73A),
            200: const Color(0xFFF8D73A),
            300: const Color(0xFFF8D73A),
            400: const Color(0xFFF8D73A),
            500: const Color(0xFFF8D73A),
            600: const Color(0xFFF8D73A),
            700: const Color(0xFFF8D73A),
            800: const Color(0xFFF8D73A),
            900: const Color(0xFFF8D73A),
          },
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
