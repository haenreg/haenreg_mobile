// main.dart

import 'package:flutter/material.dart';
import 'package:haenreg_mobile/pages/home-page.dart'; // Import the new home_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HænReg',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF83A8C9)),
        useMaterial3: true,
      ),
      home: const HomePage(), // Use the new HomePage here
    );
  }
}
