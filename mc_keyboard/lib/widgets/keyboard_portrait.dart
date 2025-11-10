import 'dart:math';
import 'package:flutter/material.dart';

class KeyboardPortrait extends StatelessWidget {
  const KeyboardPortrait({
    super.key,
    required this.isLeft,
    required this.getKeySize,
    required this.isShiftActive,
    required this.disableNonBackspace,
    required this.onShift,
    required this.onBackspace,
    required this.onKey,
  });

  final bool isLeft;
  final Size Function(String letter) getKeySize;
  final bool isShiftActive;
  final bool disableNonBackspace;
  final VoidCallback onShift;
  final VoidCallback onBackspace;
  final void Function(String letter) onKey;

  @override
  Widget build(BuildContext context) {
    var keys = [
      ['p', 'o', 'i', 'u', 'y', 't', 'r', 'e', 'w', 'q'],
      ['l', 'k', 'j', 'h', 'g', 'f', 'd', 's', 'a'],
      ['⌫', 'm', 'n', 'b', 'v', 'c', 'x', 'z', '⇧'],
      ['.', ' ', ','],
    ];
    if (isLeft) {
      keys = [
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
                keys
                    .map(
                      (column) => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: column.map(_buildKey).toList(),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }

  Widget _buildKey(String letter) {
    final isSpace = letter == ' ';
    final isBackspace = letter == '⌫';
    final isShift = letter == '⇧';

    final displayLetter =
        (!isShift && !isBackspace && !isSpace && isShiftActive)
            ? letter.toUpperCase()
            : letter;

    final keySize = getKeySize(letter);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: keySize.height,
        height: keySize.width,
        child: RotatedBox(
          quarterTurns: 3,
          child: ElevatedButton(
            onPressed:
                (disableNonBackspace && !isBackspace)
                    ? null
                    : () {
                      if (isShift) {
                        onShift();
                      } else if (isBackspace) {
                        onBackspace();
                      } else {
                        onKey(isSpace ? ' ' : letter);
                      }
                    },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
              backgroundColor:
                  (disableNonBackspace && !isBackspace && !isShift)
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
