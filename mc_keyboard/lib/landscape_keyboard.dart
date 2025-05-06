import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mc_keyboard/portrait_keyboard.dart';

class LandscapeTypingScreen extends StatefulWidget {
  const LandscapeTypingScreen({super.key});

  @override
  State<LandscapeTypingScreen> createState() => _LandscapeTypingScreenState();
}

class _LandscapeTypingScreenState extends State<LandscapeTypingScreen> {
  final String templateText =
      'This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants.';
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

  Size getKeySize(String letter) {
    const letterSize = Size(35, 40);
    const spaceSize = Size(300, 40);
    const specialSize = Size(55, 40);

    if (letter == ' ') {
      return spaceSize;
    } else if (letter == '⌫' || letter == '⇧') {
      return specialSize;
    } else if (letter == ',' || letter == '.') {
      return letterSize;
    } else {
      return letterSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          isLandscape
              ? Column(
                children: [
                  // left side: text (innput)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          templateText,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        // Left bottom -> typed text
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                typedText,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        // Right bottom -> keyboard
                        Expanded(flex: 2, child: buildKeyboard()),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(
                child: Text("Please rotate your phone to landscape mode."),
              ),
          Positioned(
            right: 10,
            top: 150,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PortraitTypingScreen(),
                  ),
                );
              },
              child: const Text("P2"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKeyboard() {
    const keys = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
      [';', ' ', ':'],
    ];

    return LayoutBuilder(
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

    final keySize = getKeySize(letter);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: keySize.width,
        height: keySize.height,
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(displayLetter, style: const TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
