import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/dialogue_model.dart';
import '../../presentation/widgets/game/game_menu.dart';
import '../../presentation/widgets/game/grammar_popup.dart';
import '../../presentation/widgets/game/vocabulary_popup.dart';
import '../../presentation/widgets/home/settings_panel.dart';
import '../../providers/database_provider.dart';
import '../../providers/game_providers.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../providers/sound_controller.dart';

import '../../providers/game_controller_provider.dart';
import '../widgets/common/learning_journal_notification.dart';
import '../widgets/game/cultural_note_popup.dart';

import '../widgets/game/background_layer.dart';
import '../widgets/game/choices_list.dart';
import '../widgets/game/dialogue_box_wrapper.dart';
import '../widgets/game/top_ui_bar.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String? chapterId;
  final String? saveId;

  const GameScreen({
    super.key,
    this.chapterId,
    this.saveId,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _backgroundController;
  late AnimationController _dialogueController;
  late AnimationController _spriteController;
  late AnimationController _choicesController;

  @override
  void initState() {
    super.initState();

    _initializeAnimationControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameScreenControllerProvider.notifier).initialize(
            chapterId: widget.chapterId,
            saveId: widget.saveId,
          );
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _dialogueController.dispose();
    _spriteController.dispose();
    _choicesController.dispose();
    super.dispose();
  }

  void _initializeAnimationControllers() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _dialogueController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _spriteController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _choicesController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _advanceDialogue() {
    final controller = ref.read(gameScreenControllerProvider.notifier);
    final state = ref.read(gameScreenControllerProvider);
    final currentDialogue = ref.read(currentDialogueProvider).valueOrNull;

    if (currentDialogue == null) return;

    if (!state.isTextComplete) {
      controller.setTextComplete(true);
      return;
    }

    if (currentDialogue.isChoiceNode && state.showChoices) {
      return;
    }

    if (currentDialogue.isChoiceNode && !state.showChoices) {
      controller.showDialogueChoices();
      _choicesController.forward(from: 0.0);
      return;
    }

    _nextDialogue();
  }

  void _nextDialogue() {
    final controller = ref.read(gameScreenControllerProvider.notifier);
    final currentDialogue = ref.read(currentDialogueProvider).valueOrNull;

    if (currentDialogue == null) return;

    controller.hideChoices();

    if (!currentDialogue.isChoiceNode && currentDialogue.line.nextId != null) {
      ref.read(currentDialogueIdProvider.notifier).state = currentDialogue.line.nextId;
    } else {
      _loadNextScene();
    }
  }

  void _makeChoice(DialogueChoice choice) {
    ref.read(soundControllerProvider.notifier).playClick();
    final controller = ref.read(gameScreenControllerProvider.notifier);

    if (_canMakeChoice(choice)) {
      controller.hideChoices();
      _processRelationshipChanges(choice);
      ref.read(currentDialogueIdProvider.notifier).state = choice.nextId;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to learn more Japanese to understand this option.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _canMakeChoice(DialogueChoice choice) {
    final settings = ref.read(gameplaySettingsProvider);
    final userLanguageLevel = settings['languageLevel'] as int? ?? 5;
    return choice.requiredLevel <= userLanguageLevel;
  }

  Future<void> _processRelationshipChanges(DialogueChoice choice) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    try {
      for (final entry in choice.relationshipChanges.entries) {
        final characterId = int.tryParse(entry.key);
        final pointChange = entry.value;

        if (characterId != null) {
          await gameRepository.updateRelationshipPoints(
            activeSaveId,
            characterId,
            pointChange,
          );
        }
      }
    } catch (e, stack) {
      AppLogger.error('Error processing relationship changes', error: e, stackTrace: stack);
    }
  }

  Future<void> _loadNextScene() async {
    final controller = ref.read(gameScreenControllerProvider.notifier);
    final gameRepository = ref.read(gameRepositoryProvider);
    final currentChapterId = ref.read(activeChapterIdProvider);
    final currentSceneId = ref.read(activeSceneIdProvider);

    if (currentChapterId == null || currentSceneId == null) {
      AppLogger.error('Cannot load next scene: chapter or scene ID is null');
      return;
    }

    try {
      ref.read(isLoadingDialogueProvider.notifier).state = true;

      final chapter = await gameRepository.loadChapter(currentChapterId);
      if (chapter == null) {
        throw Exception('Chapter $currentChapterId not found');
      }

      final currentSceneIndex = chapter.sceneIds.indexOf(currentSceneId);
      if (currentSceneIndex == -1) {
        throw Exception('Current scene $currentSceneId not found in chapter');
      }

      if (currentSceneIndex < chapter.sceneIds.length - 1) {
        controller.startSceneTransition();
        await Future.delayed(const Duration(milliseconds: 800));

        final nextSceneId = chapter.sceneIds[currentSceneIndex + 1];
        ref.read(activeSceneIdProvider.notifier).state = nextSceneId;
        ref.read(currentDialogueIdProvider.notifier).state = null;

        await _saveProgress(currentChapterId, nextSceneId);
        controller.endSceneTransition();

        AppLogger.info('Loaded next scene: $nextSceneId');

        if (mounted) {
          await controller.captureBackgroundScreenshot(context);
        }
      } else {
        await _handleChapterEnd(currentChapterId);
      }
    } catch (e, stack) {
      AppLogger.error('Error loading next scene', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading next scene: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      ref.read(isLoadingDialogueProvider.notifier).state = false;
    }
  }

  Future<void> _handleChapterEnd(String currentChapterId) async {
    final controller = ref.read(gameScreenControllerProvider.notifier);
    final gameRepository = ref.read(gameRepositoryProvider);

    try {
      final allChapters = await gameRepository.getAllChapters();
      final currentChapterIndex = allChapters.indexWhere((c) => c.id == currentChapterId);

      if (currentChapterIndex == -1) {
        throw Exception('Current chapter $currentChapterId not found');
      }

      if (currentChapterIndex < allChapters.length - 1) {
        final nextChapter = allChapters[currentChapterIndex + 1];

        controller.startChapterTransition(nextChapter.title);
        await Future.delayed(const Duration(milliseconds: 2000));
        controller.endChapterTransition();

        if (mounted) {
          final goToNextChapter = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Chapter Complete'),
                  content: Text('Do you want to continue to ${nextChapter.title}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Return to Menu'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (goToNextChapter) {
            ref.read(activeChapterIdProvider.notifier).state = nextChapter.id;
            ref.read(activeSceneIdProvider.notifier).state = nextChapter.startSceneId;
            ref.read(currentDialogueIdProvider.notifier).state = null;

            await _saveProgress(nextChapter.id, nextChapter.startSceneId);
            AppLogger.info('Started next chapter: ${nextChapter.id}');

            if (mounted) {
              await controller.captureBackgroundScreenshot(context);
            }
          } else {
            if (mounted) context.go(AppConstants.routeHome);
          }
        }
      } else {
        await _showGameCompleteScreen();
      }
    } catch (e, stack) {
      AppLogger.error('Error handling chapter end', error: e, stackTrace: stack);
    }
  }

  Future<void> _saveProgress(String chapterId, String sceneId) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);
    final state = ref.read(gameScreenControllerProvider);

    if (activeSaveId == null) {
      AppLogger.warning('Cannot save progress: no active save ID');
      return;
    }

    try {
      final saveGame = await gameRepository.getSaveGameById(activeSaveId);
      if (saveGame != null) {
        final updatedSave = saveGame.copyWith(
          currentChapter: chapterId,
          currentScene: sceneId,
          playTimeSeconds: state.elapsedPlayTime,
          lastSavedAt: DateTime.now(),
        );

        await gameRepository.updateSaveGame(updatedSave);
        AppLogger.info('Progress saved: chapter=$chapterId, scene=$sceneId');
      }
    } catch (e, stack) {
      AppLogger.error('Failed to save progress', error: e, stackTrace: stack);
    }
  }

  Future<void> _showGameCompleteScreen() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text(
          'You have completed all available chapters of Tsuzuki Connect. Thank you for playing!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppConstants.routeHome);
            },
            child: const Text('Return to Menu'),
          ),
        ],
      ),
    );
  }

  Future<void> _quickSave({bool saveAndExit = false}) async {
    final controller = ref.read(gameScreenControllerProvider.notifier);
    final state = ref.read(gameScreenControllerProvider);
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    controller.closeMenu();

    if (activeSaveId == null) return;

    try {
      final save = await gameRepository.getSaveGameById(activeSaveId);

      if (save != null) {
        final currentChapterId = ref.read(activeChapterIdProvider) ?? save.currentChapter;
        final currentSceneId = ref.read(activeSceneIdProvider) ?? save.currentScene;

        final thumbnailPath = await controller.captureScreenshot(context, forSaving: true);

        await gameRepository.createQuickSave(
          currentSaveId: activeSaveId,
          playerName: save.playerName,
          currentChapter: currentChapterId,
          currentScene: currentSceneId,
          playTimeSeconds: state.elapsedPlayTime,
          thumbnailPath: thumbnailPath,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game saved successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (saveAndExit) context.go(AppConstants.routeHome);
        }

        AppLogger.info('Game saved: chapter: $currentChapterId, scene: $currentSceneId');
      }
    } catch (e, stack) {
      AppLogger.error('Error saving game', error: e, stackTrace: stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving game'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Do you want to save your progress before exiting?'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              Navigator.of(context).pop();
              context.go(AppConstants.routeHome);
            },
            child: const Text('Exit Without Saving'),
          ),
          TextButton(
            onPressed: () async {
              ref.read(soundControllerProvider.notifier).playClick();
              Navigator.of(context).pop();
              await _quickSave(saveAndExit: true);
            },
            child: const Text('Save and Exit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(gameScreenControllerProvider.notifier);
    final state = ref.watch(gameScreenControllerProvider);
    final currentDialogue = ref.watch(currentDialogueProvider).valueOrNull;
    final isLoading = ref.watch(isLoadingDialogueProvider) || state.isInitializing;

    // Get settings
    final textSpeed = ref.watch(textSpeedProvider);
    final displaySettings = ref.watch(displaySettingsProvider);
    final showFurigana = displaySettings['showFurigana'] as bool? ?? true;
    final showRomaji = displaySettings['showRomaji'] as bool? ?? false;

    // Listen to dialogue changes
    ref.listen(
      currentDialogueProvider,
      (previous, next) {
        if (next.valueOrNull != null && mounted) {
          controller.updateCharacterSprites(next.value!.line, context);
          controller.checkAndUnlockCharacter(next.value!.line);
          controller.checkForLearningMoments(next.value!.line);

          controller.setTextComplete(false);
          _dialogueController.forward(from: 0.0);
          _spriteController.forward(from: 0.0);
        }
      },
    );

    return Screenshot(
      controller: controller.screenshotController,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: SettingsPanel(
          onClose: () {
            ref.read(soundControllerProvider.notifier).playClick();
            _scaffoldKey.currentState?.closeEndDrawer();
          },
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            BackgroundLayer(backgroundImage: state.currentBackground),

            // Character sprites
            ...state.characterSprites,

            // Main UI
            Column(
              children: [
                TopUIBar(
                  onBack: _showExitConfirmation,
                  onSkip: controller.toggleSkipMode,
                  onAuto: controller.toggleAutoMode,
                  onMenu: controller.toggleMenu,
                  isSkipping: state.isSkipping,
                  isAutoMode: state.isAutoMode,
                ),
                const Spacer(),
                if (!isLoading)
                  DialogueBoxWrapper(
                    currentDialogue: currentDialogue,
                    characters: state.characters,
                    onAdvance: _advanceDialogue,
                    onTextComplete: () => controller.setTextComplete(true),
                    textSpeed: textSpeed,
                    showFurigana: showFurigana,
                    showRomaji: showRomaji,
                    isSkipping: state.isSkipping,
                    animationController: _dialogueController,
                    onVocabTap: controller.showVocabPopup,
                    onGrammarTap: controller.showGrammarPopup,
                    onCultureTap: controller.showCulturalNotePopup,
                  ),
              ],
            ),

            // Choices
            if (state.showChoices && currentDialogue != null && currentDialogue.choices.isNotEmpty)
              ChoicesList(
                choices: currentDialogue.choices,
                onChoiceSelected: _makeChoice,
                canMakeChoice: _canMakeChoice,
                showFurigana: showFurigana,
                animationController: _choicesController,
              ),

            // Game menu
            if (state.isMenuOpen)
              GameMenu(
                onClose: controller.toggleMenu,
                onSave: _quickSave,
                onLoad: () => context.push(AppConstants.routeHome),
                onSettings: () => _scaffoldKey.currentState?.openEndDrawer(),
                onExit: () => context.go(AppConstants.routeHome),
              ).animate().fadeIn(duration: 200.ms),

            // Vocabulary popup
            if (state.showVocabPopup && currentDialogue != null)
              VocabularyPopup(
                vocabularyIds: currentDialogue.line.vocabularyIds,
                onClose: controller.closePopups,
              ).animate().fadeIn(duration: 300.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),

            // Grammar popup
            if (state.showGrammarPopup && currentDialogue != null)
              GrammarPopup(
                grammarIds: currentDialogue.line.grammarIds,
                onClose: controller.closePopups,
              ).animate().fadeIn(duration: 300.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),

            // Cultural note popup
            if (state.showCulturalNotePopup && currentDialogue != null)
              CulturalNotePopup(
                culturalNoteIds: currentDialogue.line.culturalNoteIds,
                onClose: controller.closePopups,
              ).animate().fadeIn(duration: 300.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),

            // Scene transition
            if (state.isSceneTransitioning)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),

            // Chapter transition
            if (state.isChapterTransitioning)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CHAPTER',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.nextChapterTitle,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 800.ms),
                ),
              ),

            // Loading indicator
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),

            // Journal notification
            if (state.showJournalNotification)
              LearningJournalNotification(
                vocabCount: state.newLearningItems['vocab']!,
                grammarCount: state.newLearningItems['grammar']!,
                cultureCount: state.newLearningItems['culture']!,
                onVocabTap: controller.showVocabPopup,
                onGrammarTap: controller.showGrammarPopup,
                onCultureTap: controller.showCulturalNotePopup,
                onDismiss: controller.closePopups,
              ),
          ],
        ),
      ),
    );
  }
}
