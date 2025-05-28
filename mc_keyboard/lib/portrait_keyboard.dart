import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mc_keyboard/start_screen.dart';

class PortraitTypingScreen extends StatefulWidget {
  const PortraitTypingScreen({super.key});

  @override
  State<PortraitTypingScreen> createState() => _PortraitTypingScreenState();
}

class _PortraitTypingScreenState extends State<PortraitTypingScreen> {
  final String practiceText =
      'Thanks for your concern.Best of luck and stay in touch.Scotty and I will be in NYC.This seems fine to me.Just wanted to touch base.It is still going on, quite boring though.That would likely be an expensive option.The contract is a bit complicated.Apologize to Steve Dowd for me.Call me to give me a heads up.';
  final String templateText =
      'You snooze you lose.We probably have to discuss trade behavior and margin.Very foggy this AM.I think we are doing OK.Tax gave us the same feedback.Please let me know if you learn anything at the floor meeting.I can review afterwards and get back to you tonight.I am on my way back there to do so.I would be glad to participate.We will sign tomorrow and fund Tuesday.It will probably be tomorrow.I have thirty minutes then.Please pass along my thanks, though.I think Tim wants to move quickly.What will happen to this project.';

  String typedText = '';
  late List<String> sentences;
  int sentenceCounter = 0;
  bool isPractice = true;

  bool isShiftActive = true;
  bool isFirstKeyPressed = true;
  bool isLeft = false;

  bool disableKeys = false;
  bool enableBackspaceOnly = false;

  DateTime? startTime;
  DateTime? endTime;
  int backspaceCount = 0;

  bool showFinalPopup = false;
  bool showPracticePopup = false;

  @override
  void initState() {
    super.initState();
    if (isPractice) {
      sentences =
          practiceText
              .split(RegExp(r'(?<=\.)\s*'))
              .where((s) => s.isNotEmpty)
              .toList();
    }
  }

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
      final expectedLetter = sentences[sentenceCounter][currentIndex];

      // Mismatch check
      if (letter != expectedLetter) {
        disableKeys = true;
        enableBackspaceOnly = true;
        return;
      }

      if (letter == '.') {
        sentenceCounter += 1;
        typedText = '';
        isShiftActive = true;
        if (sentenceCounter == sentences.length) {
          sentenceCounter -= 1;
          endTime = DateTime.now();
          if (isPractice) {
            showPracticePopup = true;
          } else {
            showFinalPopup = true;
          }
        }
      }
    });
  }

  Size getKeySize(String letter) {
    var letterSize = Size(
      MediaQuery.sizeOf(context).height * 0.069,
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

    if (showFinalPopup) {
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
                      'Time tracked: ${endTime!.difference(startTime!).inSeconds} second',
                    ),
                    Text(
                      'Avg time per char: ${double.parse(((endTime!.difference(startTime!).inMilliseconds) / templateText.length).toStringAsFixed(2))} ms',
                    ),
                    Text('Error count: $backspaceCount'),
                    Text(
                      'Error rate: ${double.parse((backspaceCount / templateText.length).toStringAsFixed(4))}',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      showFinalPopup = false;
                    });
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      });
    }

    if (showPracticePopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Practice Done!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Time tracked: ${endTime!.difference(startTime!).inMilliseconds} ms',
                    ),
                    Text(
                      'Avg time per char: ${double.parse(((endTime!.difference(startTime!).inMilliseconds) / practiceText.length).toStringAsFixed(2))} ms',
                    ),
                    Text('Error count: $backspaceCount'),
                    Text(
                      'Error rate: ${double.parse((backspaceCount / practiceText.length).toStringAsFixed(4))}',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Start Actual Test'),
                  onPressed: () {
                    setState(() {
                      showPracticePopup = false;
                    });
                    Navigator.of(context).pop();
                    isPractice = false;
                    setState(() {
                      sentences =
                          templateText
                              .split(RegExp(r'(?<=\.)\s*'))
                              .where((s) => s.isNotEmpty)
                              .toList();
                      typedText = '';
                      sentenceCounter = 0;
                      backspaceCount = 0;
                      isFirstKeyPressed = true;
                    });
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
                ? Row(
                  children: [
                    Expanded(flex: 9, child: buildKeyboard(isLeft)),
                    const VerticalDivider(width: 1, color: Colors.purple),
                    // Left Side: Text Input
                    Expanded(
                      flex: 41,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentences[sentenceCounter],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Colors.purple),
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
                  ],
                )
                : const Center(
                  child: Text("Please rotate your phone to landscape mode."),
                ),

            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      setState(() {
                        isLeft = !isLeft;
                      });
                    },
                    child: const Text("->"),
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
                ? Row(
                  children: [
                    // Left Side: Text Input
                    Expanded(
                      flex: 41,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentences[sentenceCounter],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Colors.purple),
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

                    const VerticalDivider(width: 1, color: Colors.purple),

                    // Right Side: Keyboard
                    Expanded(flex: 9, child: buildKeyboard(isLeft)),
                  ],
                )
                : const Center(
                  child: Text("Please rotate your phone to landscape mode."),
                ),

            Positioned(
              left: 10,
              bottom: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      setState(() {
                        isLeft = !isLeft;
                      });
                    },
                    child: const Text("<-"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildKeyboard(isLeft) {
    var columns = [
      ['p', 'o', 'i', 'u', 'y', 't', 'r', 'e', 'w', 'q'],
      ['l', 'k', 'j', 'h', 'g', 'f', 'd', 's', 'a'],
      ['⌫', 'm', 'n', 'b', 'v', 'c', 'x', 'z', '⇧'],
      ['.', ' ', ','],
    ];

    if (isLeft) {
      columns = [
        ['.', ' ', ','],
        ['⌫', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⇧'],
        ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
        ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: const Color.fromARGB(255, 242, 227, 245),
          padding: EdgeInsets.only(
            bottom: 0.0,
            top:
                (MediaQuery.sizeOf(context).height -
                    MediaQuery.sizeOf(context).width * 0.4),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                columns.map((column) {
                  return SizedBox(
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
                          if (typedText.length == 0) {
                            isShiftActive = true;
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
                  (disableKeys && !isBackspace && !isShift)
                      ? Colors.red
                      : (isShift && isShiftActive
                          ? Colors.purple
                          : Colors.white),
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
