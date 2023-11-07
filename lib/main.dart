import 'package:flutter/material.dart';
import 'package:strom/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strømpris',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 206, 162, 19)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Strømpris'),
    );
  }
}
