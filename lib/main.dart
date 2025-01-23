import 'package:flutter/material.dart';
import 'package:utang/auth/loginpage.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Hutang',
      theme: ThemeData(
        primaryColor: const Color(0xFF008975),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008975)),
      ),
      home: const LoginPage(),
    );
  }
}
