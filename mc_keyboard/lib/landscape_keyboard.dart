import 'package:flutter/material.dart';

import 'package:mc_keyboard/portrait_keyboard.dart';

class LandscapeTypingScreen extends StatefulWidget {
  const LandscapeTypingScreen({super.key});

  @override
  State<LandscapeTypingScreen> createState() => _LandscapeTypingScreenState();
}

class _LandscapeTypingScreenState extends State<LandscapeTypingScreen> {
  final String templateText = 'Test';
  // 'This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants.';
  String typedText = '';

  bool isShiftActive = false; // shift key state
  bool isFirstKeyPressed = true;
  bool isLeft = false;

  bool disableKeys = false;
  bool enableBackspaceOnly = false;

  DateTime? startTime;
  DateTime? endTime;
  int backspaceCount = 0;

  bool showPopup = false;

  void onKeyPressed(String letter) {
    setState(() {
      if (isFirstKeyPressed) {
        startTime = DateTime.now();
        isFirstKeyPressed = false;
      }

      // Shift check
      if (isShiftActive) {
        letter = letter.toUpperCase();
        isShiftActive = false;
      }

      typedText += letter;

      final currentIndex = typedText.length - 1;
      final expectedLetter = templateText[currentIndex];

      // Mismatch check
      if (letter != expectedLetter) {
        disableKeys = true;
        enableBackspaceOnly = true;
        return;
      }

      // Completion check
      if (typedText.length == templateText.length) {
        endTime = DateTime.now();
        showPopup = true;
      }
    });
  }

  Size getKeySize(String letter) {
    var letterSize = Size(
      MediaQuery.sizeOf(context).height * 0.065,
      MediaQuery.sizeOf(context).width * 0.038,
    );
    var spaceSize = Size(
      MediaQuery.sizeOf(context).height * 0.55,
      MediaQuery.sizeOf(context).width * 0.038,
    );
    var specialSize = Size(
      MediaQuery.sizeOf(context).height * 0.1,
      MediaQuery.sizeOf(context).width * 0.038,
    );

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

    if (showPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Done!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Time tracked: ${endTime!.difference(startTime!).inSeconds} seconds',
                    ),
                    Text('Error count: $backspaceCount'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      showPopup = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
    if (isLeft) {
      return Scaffold(
        body: Stack(
          children: [
            isLandscape
                ? Column(
                  children: [
                    // Left Side: Text Input
                    Expanded(
                      flex: (MediaQuery.sizeOf(context).height * 3 / 4).floor(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            templateText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: 1, color: Colors.blue),

                    Expanded(
                      flex: (MediaQuery.sizeOf(context).height * 2 / 4).floor(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 0.8 * MediaQuery.sizeOf(context).height,
                            height: MediaQuery.sizeOf(context).width * 0.30,
                            child: buildKeyboard(),
                          ),

                          const VerticalDivider(width: 10, color: Colors.blue),

                          // Left bottom -> typed text
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  reverse: true,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    typedText,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 97, 97, 97),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
              top: 100,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PortraitTypingScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "P - P",
                      style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                    onPressed: () {
                      setState(() {
                        isLeft = false;
                      });
                    },
                    child: const Text(
                      "->",
                      style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            isLandscape
                ? Column(
                  children: [
                    // left side: text (innput)
                    Expanded(
                      flex: (MediaQuery.sizeOf(context).height * 3 / 4).floor(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            templateText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: 1, color: Colors.blue),

                    Expanded(
                      flex: (MediaQuery.sizeOf(context).height * 2 / 4).floor(),
                      child: Row(
                        children: [
                          // Left bottom -> typed text
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  reverse: true,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    typedText,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 97, 97, 97),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const VerticalDivider(width: 10, color: Colors.blue),

                          // Right bottom -> keyboard
                          SizedBox(
                            width: 0.8 * MediaQuery.sizeOf(context).height,
                            height: MediaQuery.sizeOf(context).width * 0.30,
                            child: buildKeyboard(),
                          ),
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
              top: 100,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PortraitTypingScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "P - P",
                      style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                    onPressed: () {
                      setState(() {
                        isLeft = true;
                      });
                    },
                    child: const Text(
                      "<-",
                      style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
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
          color: const Color.fromARGB(255, 227, 238, 247),

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
          onPressed:
              (disableKeys && !isBackspace)
                  ? null
                  : () {
                    setState(() {
                      if (isShift) {
                        isShiftActive = !isShiftActive;
                      } else if (isBackspace) {
                        if (typedText.isNotEmpty) {
                          typedText = typedText.substring(
                            0,
                            typedText.length - 1,
                          );
                        }
                        backspaceCount += 1;
                        disableKeys = false;
                        enableBackspaceOnly = false;
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
