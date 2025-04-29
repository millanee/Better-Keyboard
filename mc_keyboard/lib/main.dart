import 'package:flutter/material.dart';
import 'dart:math';

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

class LandscapeTypingScreen extends StatefulWidget {
  const LandscapeTypingScreen({super.key});

  @override
  State<LandscapeTypingScreen> createState() => _LandscapeTypingScreenState();
}

class _LandscapeTypingScreenState extends State<LandscapeTypingScreen> {
  final String templateText =
      'This text needs to be typed by the participants.';
  String typedText = '';
  bool isShiftActive = false; // shift key state

  void onKeyPressed(String letter) {
    setState(() {
      if (isShiftActive) {
        typedText += letter.toUpperCase();
        isShiftActive = false; // turn off shift after one letter was pressed
      } else {
        typedText += letter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body:
          isLandscape
              ? Row(
                children: [
                  // left side: text (innput)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            templateText,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(
                            typedText,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  // Right side: keyboard
                  Expanded(flex: 2, child: buildKeyboard()),
                ],
              )
              : const Center(
                child: Text("Please rotate your phone to landscape mode."),
              ),
    );
  }

  Widget buildKeyboard() {
    const keys = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['z', 'x', 'c', 'v', 'b', 'n', 'm', ';', ':'],
      ['⇧', '⌫', ' '],
    ];

    return Transform.rotate(
      angle: -pi / 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxHeight,
            height: constraints.maxWidth,
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  keys.map((row) {
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map(buildKey).toList(),
                      ),
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget buildKey(String letter) {
    final isSpace = letter == ' ';
    final isBackspace = letter == '⌫';
    final isShift = letter == '⇧';

    // What is displayed:
    String displayLetter = letter;
    if (!isShift && !isBackspace && !isSpace && isShiftActive) {
      displayLetter = letter.toUpperCase();
    }

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isShift) {
                  isShiftActive = !isShiftActive;
                } else if (isBackspace) {
                  if (typedText.isNotEmpty) {
                    typedText = typedText.substring(0, typedText.length - 1);
                  }
                } else {
                  onKeyPressed(isSpace ? ' ' : letter);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
              backgroundColor:
                  isShift && isShiftActive ? Colors.blue : Colors.white,
              foregroundColor: Colors.black,
              elevation: 2,
            ),
            child: Transform.rotate(
              angle: pi / 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  displayLetter,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
