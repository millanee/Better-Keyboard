import 'package:flutter/material.dart';
import 'package:mc_keyboard/landscape_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landscape Keyboard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandscapeTypingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
