import 'package:flutter/material.dart';
import 'package:mc_keyboard/screens/typing_screen_base.dart';
import 'package:mc_keyboard/widgets/prompt_panel.dart';
import 'package:mc_keyboard/widgets/typed_text_box.dart';
import 'package:mc_keyboard/widgets/keyboard_portrait.dart';

class PortraitTypingScreen extends TypingScreenBase {
  const PortraitTypingScreen({super.key})
    : super(
        practiceText:
            'Thanks for your concern.Best of luck and stay in touch.Scotty and I will be in NYC.This seems fine to me.Just wanted to touch base.It is still going on, quite boring though.That would likely be an expensive option.The contract is a bit complicated.Apologize to Steve Dowd for me.Call me to give me a heads up.',
        templateText:
            'You snooze you lose.We probably have to discuss trade behavior and margin.Very foggy this AM.I think we are doing OK.Tax gave us the same feedback.Please let me know if you learn anything at the floor meeting.I can review afterwards and get back to you tonight.I am on my way back there to do so.I would be glad to participate.We will sign tomorrow and fund Tuesday.It will probably be tomorrow.I have thirty minutes then.Please pass along my thanks, though.I think Tim wants to move quickly.What will happen to this project.',
      );

  @override
  State<PortraitTypingScreen> createState() => _PortraitTypingScreenState();
}

class _PortraitTypingScreenState
    extends TypingScreenBaseState<PortraitTypingScreen> {
  @override
  Widget buildOriginalLayout(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final prompt = PromptPanel(text: controller.currentPrompt);
    final typed = TypedTextBox(text: controller.typed);

    if (isLeft) {
      return Scaffold(
        body: Stack(
          children: [
            isLandscape
                ? Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: KeyboardPortrait(
                        isLeft: true,
                        getKeySize: (l) => getKeySize(context, l), // ← rename
                        isShiftActive: controller.isShiftActive,
                        disableNonBackspace: controller.disableNonBackspace,
                        onShift: () => setState(() => controller.toggleShift()),
                        onBackspace:
                            () => setState(() => controller.backspace()),
                        onKey: (l) => handleKeyPress(l),
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Colors.purple),
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
                            prompt,
                            const SizedBox(height: 20),
                            const Divider(color: Colors.purple),
                            const SizedBox(height: 10),
                            Expanded(flex: 2, child: typed),
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
              child: FloatingActionButton(
                mini: true,
                onPressed: () => setState(() => isLeft = !isLeft),
                child: const Text("->"),
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
                            prompt,
                            const SizedBox(height: 20),
                            const Divider(color: Colors.purple),
                            const SizedBox(height: 10),
                            Expanded(flex: 2, child: typed),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Colors.purple),
                    Expanded(
                      flex: 9,
                      child: KeyboardPortrait(
                        isLeft: false,
                        getKeySize: (l) => getKeySize(context, l),
                        isShiftActive: controller.isShiftActive,
                        disableNonBackspace: controller.disableNonBackspace,
                        onShift: () => setState(() => controller.toggleShift()),
                        onBackspace:
                            () => setState(() => controller.backspace()),
                        onKey: (l) => handleKeyPress(l),
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
                onPressed: () => setState(() => isLeft = !isLeft),
                child: const Text("<-"),
              ),
            ),
          ],
        ),
      );
    }
  }
}
