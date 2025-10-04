import 'package:flutter/material.dart';

import '../../../data/models/dialogue_model.dart';
import 'choice_button.dart';

/// Displays the list of dialogue choices with animations
class ChoicesList extends StatelessWidget {
  final List<DialogueChoice> choices;
  final Function(DialogueChoice) onChoiceSelected;
  final bool Function(DialogueChoice) canMakeChoice;
  final bool showFurigana;
  final AnimationController animationController;

  const ChoicesList({
    super.key,
    required this.choices,
    required this.onChoiceSelected,
    required this.canMakeChoice,
    required this.showFurigana,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.9 + (animationController.value * 0.1),
            child: Opacity(
              opacity: animationController.value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: _buildChoicesLayout(context),
        ),
      ),
    );
  }

  Widget _buildChoicesLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Use wrap layout for small screens
    if (screenHeight < 600) {
      return _buildWrapChoices(screenHeight);
    }

    // Use column layout for normal screens
    return _buildColumnChoices();
  }

  Widget _buildWrapChoices(double screenHeight) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        choices.length,
        (i) => ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenHeight * 0.5,
          ),
          child: _buildChoiceButton(choices[i], i),
        ),
      ),
    );
  }

  Widget _buildColumnChoices() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        choices.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildChoiceButton(choices[i], i),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(DialogueChoice choice, int index) {
    return ChoiceButton(
      choice: choice,
      onTap: () => onChoiceSelected(choice),
      showFurigana: showFurigana,
      canMakeChoice: canMakeChoice(choice),
      index: index,
    );
  }
}
