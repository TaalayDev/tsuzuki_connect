import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/models/character_model.dart';
import '../../../data/models/dialogue_model.dart';
import 'dialogue_box.dart';

/// Wrapper widget for the dialogue box with animations
class DialogueBoxWrapper extends StatelessWidget {
  final DialogueNode? currentDialogue;
  final Map<String, CharacterModel> characters;
  final VoidCallback onAdvance;
  final VoidCallback onTextComplete;
  final int textSpeed;
  final bool showFurigana;
  final bool showRomaji;
  final bool isSkipping;
  final VoidCallback? onVocabTap;
  final VoidCallback? onGrammarTap;
  final VoidCallback? onCultureTap;
  final AnimationController animationController;

  const DialogueBoxWrapper({
    super.key,
    required this.currentDialogue,
    required this.characters,
    required this.onAdvance,
    required this.onTextComplete,
    required this.textSpeed,
    required this.showFurigana,
    required this.showRomaji,
    required this.isSkipping,
    required this.animationController,
    this.onVocabTap,
    this.onGrammarTap,
    this.onCultureTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentDialogue == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: onAdvance,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - animationController.value) * 50),
              child: Opacity(
                opacity: animationController.value,
                child: DialogueBox(
                  line: currentDialogue!.line,
                  character: _getCharacter(),
                  onTextComplete: onTextComplete,
                  textSpeed: textSpeed,
                  showFurigana: showFurigana,
                  showRomaji: showRomaji,
                  instantComplete: isSkipping,
                  onVocabTap: _hasVocabulary() ? onVocabTap : null,
                  onGrammarTap: _hasGrammar() ? onGrammarTap : null,
                  onCultureTap: _hasCulturalNotes() ? onCultureTap : null,
                ),
              ),
            );
          },
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(
            begin: 0.2,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutQuad,
          ),
    );
  }

  CharacterModel? _getCharacter() {
    final characterId = currentDialogue?.line.characterId;
    if (characterId != null) {
      return characters[characterId];
    }
    return null;
  }

  bool _hasVocabulary() {
    return currentDialogue?.line.vocabularyIds.isNotEmpty ?? false;
  }

  bool _hasGrammar() {
    return currentDialogue?.line.grammarIds.isNotEmpty ?? false;
  }

  bool _hasCulturalNotes() {
    return currentDialogue?.line.culturalNoteIds.isNotEmpty ?? false;
  }
}
