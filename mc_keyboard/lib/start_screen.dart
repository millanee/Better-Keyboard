import 'package:flutter/material.dart';
import 'package:mc_keyboard/landscape_keyboard.dart';
import 'package:mc_keyboard/portrait_keyboard.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Better Landscape Keyboard')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(200, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandscapeTypingScreen(),
                  ),
                );
              },
              child: const Text("Prototype 1 - Landscape"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(200, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PortraitTypingScreen(),
                  ),
                );
              },
              child: const Text("Prototype 2 - Portrait"),
            ),
          ],
        ),
      ),
    );
  }
}
