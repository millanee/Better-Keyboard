/// Pure typing logic
class TypingController {
  TypingController({required this.practiceText, required this.templateText}) {
    _loadPractice();
  }

  final String practiceText;
  final String templateText;

  bool _isPractice = true;
  bool get isPractice => _isPractice;

  late List<String> _sentences;
  int _sentenceIndex = 0;
  String _typed = '';

  bool isShiftActive = true; // next letter uppercased, then auto-off
  bool isFirstKeyPressed = true; // start timing on first key
  bool disableNonBackspace = false;

  DateTime? _start;
  DateTime? _end;
  int backspaceCount = 0;

  bool get isDone => _end != null;
  String get currentPrompt => _sentences[_sentenceIndex];
  String get typed => _typed;

  void _loadPractice() {
    _isPractice = true;
    _sentences = _splitIntoSentences(practiceText);
    _reset();
  }

  void startActualTest() {
    _isPractice = false;
    _sentences = _splitIntoSentences(templateText);
    _reset();
  }

  void _reset() {
    _sentenceIndex = 0;
    _typed = '';
    backspaceCount = 0;
    isFirstKeyPressed = true;
    isShiftActive = true;
    disableNonBackspace = false;
    _start = null;
    _end = null;
  }

  List<String> _splitIntoSentences(String text) =>
      text.split(RegExp(r'(?<=\.)\s*')).where((s) => s.isNotEmpty).toList();

  /// Process a normal key
  TypingEvent onKey(String raw) {
    if (isDone) return TypingEvent.none();

    var ch = raw;

    if (isFirstKeyPressed) {
      _start = DateTime.now();
      isFirstKeyPressed = false;
    }
    if (isShiftActive) {
      ch = ch.toUpperCase();
      isShiftActive = false;
    }

    _typed += ch;

    final i = _typed.length - 1;
    final expected = _sentences[_sentenceIndex][i];

    if (ch != expected) {
      disableNonBackspace = true;
      return TypingEvent.mismatch();
    }

    if (ch == '.') {
      _sentenceIndex++;
      _typed = '';
      isShiftActive = true;

      if (_sentenceIndex == _sentences.length) {
        _sentenceIndex--;
        _end = DateTime.now();
        return _isPractice
            ? TypingEvent.practiceDone()
            : TypingEvent.finalDone();
      }
    }

    return TypingEvent.none();
  }

  void toggleShift() => isShiftActive = !isShiftActive;

  /// Remove last char, count as error, unlock keys
  void backspace() {
    if (_typed.isNotEmpty) {
      _typed = _typed.substring(0, _typed.length - 1);
    }
    backspaceCount++;
    disableNonBackspace = false;
    if (_typed.isEmpty) isShiftActive = true;
  }

  // Metrics
  double get totalSeconds =>
      _start == null || _end == null
          ? 0.0
          : (_end!.difference(_start!).inMilliseconds / 1000.0);

  int get referenceLength => (_isPractice ? practiceText : templateText).length;

  double get avgTimePerChar =>
      referenceLength == 0 ? 0.0 : (totalSeconds / referenceLength);

  double get errorRate =>
      referenceLength == 0 ? 0.0 : backspaceCount / referenceLength;
}

class TypingEvent {
  final bool mismatch;
  final bool practiceDone;
  final bool finalDone;

  const TypingEvent({
    required this.mismatch,
    required this.practiceDone,
    required this.finalDone,
  });

  factory TypingEvent.none() =>
      const TypingEvent(mismatch: false, practiceDone: false, finalDone: false);
  factory TypingEvent.mismatch() =>
      const TypingEvent(mismatch: true, practiceDone: false, finalDone: false);
  factory TypingEvent.practiceDone() =>
      const TypingEvent(mismatch: false, practiceDone: true, finalDone: false);
  factory TypingEvent.finalDone() =>
      const TypingEvent(mismatch: false, practiceDone: false, finalDone: true);
}
