import 'package:flutter/material.dart';
import 'package:mc_keyboard/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
