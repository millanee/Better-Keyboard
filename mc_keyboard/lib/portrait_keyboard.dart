import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mc_keyboard/landscape_keyboard.dart';

class PortraitTypingScreen extends StatefulWidget {
  const PortraitTypingScreen({super.key});

  @override
  State<PortraitTypingScreen> createState() => _PortraitTypingScreenState();
}

class _PortraitTypingScreenState extends State<PortraitTypingScreen> {
  final String templateText = 'Test';
  // 'This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants. This text needs to be typed by the participants.';
  String typedText = '';
  bool isShiftActive = false; // shift key state
  bool isFirstKeyPressed = true;
  DateTime? startTime;
  DateTime? endTime;
  bool showPopup = false;

  void onKeyPressed(String letter) {
    setState(() {
      if (isFirstKeyPressed) {
        startTime = DateTime.now();
        isFirstKeyPressed = false;
      }
      if (isShiftActive) {
        typedText += letter.toUpperCase();
        isShiftActive = false; // turn off shift after one letter was pressed
      } else {
        typedText += letter;
        if (typedText.length == templateText.length &&
            letter == templateText[templateText.length - 1]) {
          endTime = DateTime.now();
          showPopup = true;
        }
      }
    });
  }

  Size getKeySize(String letter) {
    var letterSize = Size(
      MediaQuery.sizeOf(context).height * 0.075,
      MediaQuery.sizeOf(context).width * 0.048,
    );
    var spaceSize = Size(
      MediaQuery.sizeOf(context).height * 0.6,
      MediaQuery.sizeOf(context).width * 0.048,
    );
    var specialSize = Size(
      MediaQuery.sizeOf(context).height * 0.1,
      MediaQuery.sizeOf(context).width * 0.048,
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
                      'Time tracked: ${endTime!.difference(startTime!).inMilliseconds} ms',
                    ),
                    Text('Error count: '),
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
    return Scaffold(
      body: Stack(
        children: [
          isLandscape
              ? Row(
                children: [
                  // left side: text (innput)
                  Expanded(
                    flex: (MediaQuery.sizeOf(context).height * 9 / 11).floor(),
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
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  reverse: true,
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    typedText,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  // Right side: keyboard
                  Expanded(
                    flex: (MediaQuery.sizeOf(context).height * 3 / 11).floor(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.0, top: 30.0),
                      child: buildKeyboard(),
                    ),
                  ),
                ],
              )
              : const Center(
                child: Text("Please rotate your phone to landscape mode."),
              ),
          Positioned(
            left: 10,
            bottom: 10,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandscapeTypingScreen(),
                  ),
                );
              },
              child: const Text("P1"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKeyboard() {
    // const keys = [
    //   ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    //   ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    //   ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
    //   ['⇧', ',', ' ', '.', '⌫'],
    // ];

    const columns = [
      ['p', 'o', 'i', 'u', 'y', 't', 'r', 'e', 'w', 'q'],
      ['l', 'k', 'j', 'h', 'g', 'f', 'd', 's', 'a'],
      ['⌫', 'm', 'n', 'b', 'v', 'c', 'x', 'z', '⇧'],
      ['.', ' ', ','],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                columns.map((column) {
                  return SizedBox(
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: column.map(buildKey).toList(),
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
        width: keySize.height,
        height: keySize.width,
        child: RotatedBox(
          quarterTurns: 3, // -90 degrees
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
