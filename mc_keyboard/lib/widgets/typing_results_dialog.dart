import 'package:flutter/material.dart';

class TypingResultsDialog extends StatelessWidget {
  const TypingResultsDialog({
    super.key,
    required this.title,
    required this.totalSeconds,
    required this.avgTimePerChar,
    required this.errorCount,
    required this.errorRate,
    required this.primaryText,
    required this.onPrimary,
  });

  final String title;
  final double totalSeconds;
  final double avgTimePerChar;
  final int errorCount;
  final double errorRate;
  final String primaryText;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Time tracked: ${totalSeconds.toStringAsFixed(3)} s'),
            Text('Avg time per char: ${avgTimePerChar.toStringAsFixed(4)} s'),
            Text('Error count: $errorCount'),
            Text('Error rate: ${errorRate.toStringAsFixed(4)}'),
          ],
        ),
      ),
      actions: [TextButton(onPressed: onPrimary, child: Text(primaryText))],
    );
  }
}
