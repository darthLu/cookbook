import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CookbookApp());
}

class CookbookApp extends StatelessWidget {
  const CookbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookbook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5E3C),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}