import 'package:flutter/material.dart';
import 'package:mc_keyboard/screens/typing_screen_base.dart';
import 'package:mc_keyboard/widgets/prompt_panel.dart';
import 'package:mc_keyboard/widgets/typed_text_box.dart';
import 'package:mc_keyboard/widgets/keyboard_landscape.dart';

class LandscapeTypingScreen extends TypingScreenBase {
  const LandscapeTypingScreen({super.key})
    : super(
        practiceText:
            'Thanks for your concern.Best of luck and stay in touch.Scotty and I will be in NYC.This seems fine to me.Just wanted to touch base.It is still going on, quite boring though.That would likely be an expensive option.The contract is a bit complicated.Apologize to Steve Dowd for me.Call me to give me a heads up.',
        templateText:
            'I think these will be just fine.Tell her to get my expense report done.What a crazy day.She has absolutely everything.Also it appears no payment is required tomorrow.We can have wine and catch up.Hopefully this can wait until Monday.I agree since I am at the bank right now.I changed that in one prior draft.Never mind, I already deleted it.You can talk to Becky.I changed that in one prior draft.Nothing but good news everyday.Disney was great and I have been to eight baseball games.OK to make changes, change out original.',
      );

  @override
  State<LandscapeTypingScreen> createState() => _LandscapeTypingScreenState();
}

class _LandscapeTypingScreenState
    extends TypingScreenBaseState<LandscapeTypingScreen> {
  @override
  Widget buildOriginalLayout(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final prompt = const SizedBox.shrink();
    final typed = TypedTextBox(text: controller.typed);

    if (isLeft) {
      return Scaffold(
        body: Stack(
          children: [
            isLandscape
                ? Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: PromptPanel(text: controller.currentPrompt),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.blue),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 0.8 * MediaQuery.sizeOf(context).height,
                            height: MediaQuery.sizeOf(context).width * 0.30,
                            child: KeyboardLandscape(
                              isLeft: true,
                              getKeySize: (l) => getKeySize(context, l),
                              isShiftActive: controller.isShiftActive,
                              disableNonBackspace:
                                  controller.disableNonBackspace,
                              onShift:
                                  () =>
                                      setState(() => controller.toggleShift()),
                              onBackspace:
                                  () => setState(() => controller.backspace()),
                              onKey: (l) => handleKeyPress(l),
                            ),
                          ),
                          const VerticalDivider(width: 10, color: Colors.blue),
                          Expanded(flex: 3, child: typed),
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
                backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                onPressed: () => setState(() => isLeft = false),
                child: const Text(
                  "->",
                  style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                ),
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
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          top: 30.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: PromptPanel(text: controller.currentPrompt),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.blue),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: typed),
                          const VerticalDivider(width: 10, color: Colors.blue),
                          SizedBox(
                            width: 0.8 * MediaQuery.sizeOf(context).height,
                            height: MediaQuery.sizeOf(context).width * 0.30,
                            child: KeyboardLandscape(
                              isLeft: false,
                              getKeySize: (l) => getKeySize(context, l),
                              isShiftActive: controller.isShiftActive,
                              disableNonBackspace:
                                  controller.disableNonBackspace,
                              onShift:
                                  () =>
                                      setState(() => controller.toggleShift()),
                              onBackspace:
                                  () => setState(() => controller.backspace()),
                              onKey: (l) => handleKeyPress(l),
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
              left: 10,
              top: 150,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: const Color.fromARGB(255, 190, 221, 246),
                onPressed: () => setState(() => isLeft = true),
                child: const Text(
                  "<-",
                  style: TextStyle(color: Color.fromARGB(255, 4, 64, 114)),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
