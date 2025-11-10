import 'package:flutter/material.dart';
import 'package:mc_keyboard/logic/typing_controller.dart';
import 'package:mc_keyboard/widgets/typing_results_dialog.dart';
import 'package:mc_keyboard/screens/start_screen.dart';

/// Shared controller, popups and sizing
abstract class TypingScreenBase extends StatefulWidget {
  const TypingScreenBase({
    super.key,
    required this.practiceText,
    required this.templateText,
  });

  final String practiceText;
  final String templateText;
}

abstract class TypingScreenBaseState<T extends TypingScreenBase>
    extends State<T> {
  late TypingController controller;

  bool isLeft = false;
  bool showFinalPopup = false;
  bool showPracticePopup = false;

  @override
  void initState() {
    super.initState();
    controller = TypingController(
      practiceText: widget.practiceText,
      templateText: widget.templateText,
    );
  }

  Size getKeySize(BuildContext context, String letter) {
    final letterSize = Size(
      MediaQuery.sizeOf(context).height * 0.069,
      MediaQuery.sizeOf(context).width * 0.038,
    );
    final spaceSize = Size(
      MediaQuery.sizeOf(context).height * 0.55,
      MediaQuery.sizeOf(context).width * 0.038,
    );
    final specialSize = Size(
      MediaQuery.sizeOf(context).height * 0.1,
      MediaQuery.sizeOf(context).width * 0.038,
    );
    if (letter == ' ') return spaceSize;
    if (letter == '⌫' || letter == '⇧') return specialSize;
    return letterSize;
  }

  void handleKeyPress(String letter) {
    setState(() {
      final evt = controller.onKey(letter);
      if (evt.practiceDone) {
        showPracticePopup = true;
      } else if (evt.finalDone) {
        showFinalPopup = true;
      }
    });
  }

  void maybeShowDialogs(BuildContext context) {
    if (showFinalPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => TypingResultsDialog(
                title: 'Done!',
                totalSeconds: controller.totalSeconds,
                avgTimePerChar: controller.avgTimePerChar,
                errorCount: controller.backspaceCount,
                errorRate: controller.errorRate,
                primaryText: 'OK',
                onPrimary: () {
                  setState(() => showFinalPopup = false);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StartScreen()),
                  );
                },
              ),
        );
      });
    }
    if (showPracticePopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => TypingResultsDialog(
                title: 'Practice Done!',
                totalSeconds: controller.totalSeconds,
                avgTimePerChar: controller.avgTimePerChar,
                errorCount: controller.backspaceCount,
                errorRate: controller.errorRate,
                primaryText: 'Start Actual Test',
                onPrimary: () {
                  setState(() => showPracticePopup = false);
                  Navigator.of(context).pop();
                  setState(() => controller.startActualTest());
                },
              ),
        );
      });
    }
  }

  /// Subclasses return their original Scaffold builds
  Widget buildOriginalLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    maybeShowDialogs(context);
    return buildOriginalLayout(context);
  }
}
