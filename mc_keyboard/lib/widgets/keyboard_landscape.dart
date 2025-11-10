import 'package:flutter/material.dart';

/// Landscape keyboard with the exact grid and sizes you used.
class KeyboardLandscape extends StatelessWidget {
  const KeyboardLandscape({
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
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
      ['.', ' ', ','],
    ];
    if (isLeft) {
      keys = [
        ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
        ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
        ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
        [',', ' ', '.'],
      ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxHeight,
          height: constraints.maxWidth,
          color: const Color.fromARGB(255, 227, 238, 247),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                keys
                    .map(
                      (row) => Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: row.map(_buildKey).toList(),
                        ),
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
        width: keySize.width,
        height: keySize.height,
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
                isShift && isShiftActive
                    ? Colors.blue
                    : (disableNonBackspace && !isBackspace && !isShift
                        ? Colors.red
                        : Colors.white),
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
