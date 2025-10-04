import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../data/models/character_model.dart';
import '../data/models/dialogue_model.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/screenshot_helper.dart';
import '../providers/database_provider.dart';
import '../providers/game_providers.dart';
import '../providers/settings_provider.dart';
import '../providers/app_providers.dart';
import '../providers/sound_controller.dart';

import '../data/models/save_game_model.dart';
import '../presentation/widgets/game/character_sprite.dart';

class GameScreenState {
  final bool isMenuOpen;
  final bool isSkipping;
  final bool isAutoMode;
  final bool isTextComplete;
  final String currentBackground;
  final bool isInitializing;
  final bool showChoices;
  final bool showVocabPopup;
  final bool showGrammarPopup;
  final bool showCulturalNotePopup;
  final bool isCapturingScreenshot;
  final bool isSceneTransitioning;
  final bool isChapterTransitioning;
  final String nextChapterTitle;
  final Map<String, CharacterModel> characters;
  final List<Widget> characterSprites;
  final bool showJournalNotification;
  final Map<String, int> newLearningItems;
  final int elapsedPlayTime;

  const GameScreenState({
    this.isMenuOpen = false,
    this.isSkipping = false,
    this.isAutoMode = false,
    this.isTextComplete = false,
    this.currentBackground = '',
    this.isInitializing = true,
    this.showChoices = false,
    this.showVocabPopup = false,
    this.showGrammarPopup = false,
    this.showCulturalNotePopup = false,
    this.isCapturingScreenshot = false,
    this.isSceneTransitioning = false,
    this.isChapterTransitioning = false,
    this.nextChapterTitle = '',
    this.characters = const {},
    this.characterSprites = const [],
    this.showJournalNotification = false,
    this.newLearningItems = const {'vocab': 0, 'grammar': 0, 'culture': 0},
    this.elapsedPlayTime = 0,
  });

  GameScreenState copyWith({
    bool? isMenuOpen,
    bool? isSkipping,
    bool? isAutoMode,
    bool? isTextComplete,
    String? currentBackground,
    bool? isInitializing,
    bool? showChoices,
    bool? showVocabPopup,
    bool? showGrammarPopup,
    bool? showCulturalNotePopup,
    bool? isCapturingScreenshot,
    bool? isSceneTransitioning,
    bool? isChapterTransitioning,
    String? nextChapterTitle,
    Map<String, CharacterModel>? characters,
    List<Widget>? characterSprites,
    bool? showJournalNotification,
    Map<String, int>? newLearningItems,
    int? elapsedPlayTime,
  }) {
    return GameScreenState(
      isMenuOpen: isMenuOpen ?? this.isMenuOpen,
      isSkipping: isSkipping ?? this.isSkipping,
      isAutoMode: isAutoMode ?? this.isAutoMode,
      isTextComplete: isTextComplete ?? this.isTextComplete,
      currentBackground: currentBackground ?? this.currentBackground,
      isInitializing: isInitializing ?? this.isInitializing,
      showChoices: showChoices ?? this.showChoices,
      showVocabPopup: showVocabPopup ?? this.showVocabPopup,
      showGrammarPopup: showGrammarPopup ?? this.showGrammarPopup,
      showCulturalNotePopup: showCulturalNotePopup ?? this.showCulturalNotePopup,
      isCapturingScreenshot: isCapturingScreenshot ?? this.isCapturingScreenshot,
      isSceneTransitioning: isSceneTransitioning ?? this.isSceneTransitioning,
      isChapterTransitioning: isChapterTransitioning ?? this.isChapterTransitioning,
      nextChapterTitle: nextChapterTitle ?? this.nextChapterTitle,
      characters: characters ?? this.characters,
      characterSprites: characterSprites ?? this.characterSprites,
      showJournalNotification: showJournalNotification ?? this.showJournalNotification,
      newLearningItems: newLearningItems ?? this.newLearningItems,
      elapsedPlayTime: elapsedPlayTime ?? this.elapsedPlayTime,
    );
  }
}

class GameScreenController extends StateNotifier<GameScreenState> {
  final Ref ref;
  final ScreenshotController screenshotController;

  Timer? _autoModeTimer;
  Timer? _playTimeTimer;
  DateTime? _lastScreenshotTime;

  GameScreenController(this.ref, this.screenshotController) : super(const GameScreenState());

  Future<void> initialize({String? chapterId, String? saveId}) async {
    try {
      ref.read(isLoadingDialogueProvider.notifier).state = true;
      state = state.copyWith(isInitializing: true);

      if (chapterId != null) {
        ref.read(activeChapterIdProvider.notifier).state = chapterId;
      }

      if (saveId != null) {
        final parsedSaveId = int.tryParse(saveId);
        if (parsedSaveId != null) {
          await ref.read(activeSaveIdProvider.notifier).setActiveSaveId(parsedSaveId);
          await _loadFromSave(parsedSaveId);
        }
      } else {
        await _initializeNewGame(chapterId);
      }

      await _loadCharactersForChapter();
      ref.read(inAppReviewProvider).incrementSessionCount();

      _startPlayTimeTimer();
    } catch (e, stack) {
      AppLogger.error('Error initializing game session', error: e, stackTrace: stack);
    } finally {
      ref.read(isLoadingDialogueProvider.notifier).state = false;
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<void> _loadFromSave(int saveId) async {
    try {
      final gameRepository = ref.read(gameRepositoryProvider);
      final saveGame = await gameRepository.getSaveGameById(saveId);

      if (saveGame != null) {
        ref.read(activeChapterIdProvider.notifier).state = saveGame.currentChapter;
        ref.read(activeSceneIdProvider.notifier).state = saveGame.currentScene;
        ref.read(currentPlayTimeProvider.notifier).state = saveGame.playTimeSeconds;

        state = state.copyWith(elapsedPlayTime: saveGame.playTimeSeconds);
        AppLogger.info('Loaded save game: $saveId, chapter: ${saveGame.currentChapter}');
      } else {
        AppLogger.warning('Save game not found: $saveId');
        await _initializeNewGame(null);
      }
    } catch (e, stack) {
      AppLogger.error('Error loading save game', error: e, stackTrace: stack);
      await _initializeNewGame(null);
    }
  }

  Future<void> _initializeNewGame(String? chapterId) async {
    try {
      final gameRepository = ref.read(gameRepositoryProvider);
      final targetChapterId = chapterId ?? 'chapter_1';
      final chapter = await gameRepository.loadChapter(targetChapterId);

      if (chapter != null) {
        ref.read(activeSceneIdProvider.notifier).state = chapter.startSceneId;
        ref.read(currentDialogueIdProvider.notifier).state = null;

        final availableSlot = await gameRepository.getAvailableSaveSlot() ?? 1;
        final newSaveGame = SaveGameModel.create(
          slotId: availableSlot,
          playerName: "Player",
          currentChapter: targetChapterId,
          currentScene: chapter.startSceneId,
        );

        final saveId = await gameRepository.createSaveGame(newSaveGame);
        await ref.read(activeSaveIdProvider.notifier).setActiveSaveId(saveId);

        AppLogger.info('New game initialized: chapter $targetChapterId, scene ${chapter.startSceneId}');
      }
    } catch (e, stack) {
      AppLogger.error('Error initializing new game', error: e, stackTrace: stack);
    }
  }

  Future<void> _loadCharactersForChapter() async {
    try {
      final gameRepository = ref.read(gameRepositoryProvider);
      final characters = await gameRepository.getAllCharacters();

      final characterMap = <String, CharacterModel>{};
      for (var character in characters) {
        characterMap[character.id.toString()] = character;
      }

      state = state.copyWith(characters: characterMap);
      AppLogger.info('Loaded ${characters.length} characters');
    } catch (e, stack) {
      AppLogger.error('Error loading characters', error: e, stackTrace: stack);
    }
  }

  void _startPlayTimeTimer() {
    _playTimeTimer?.cancel();
    _playTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newTime = state.elapsedPlayTime + 1;
      state = state.copyWith(elapsedPlayTime: newTime);
      ref.read(currentPlayTimeProvider.notifier).state = newTime;
    });
  }

  void toggleMenu() {
    ref.read(soundControllerProvider.notifier).playClick();
    state = state.copyWith(isMenuOpen: !state.isMenuOpen);
  }

  void closeMenu() {
    state = state.copyWith(isMenuOpen: false);
  }

  void closePopups() {
    state = state.copyWith(
      showVocabPopup: false,
      showGrammarPopup: false,
      showCulturalNotePopup: false,
      showJournalNotification: false,
    );
  }

  void showVocabPopup() {
    state = state.copyWith(
      showVocabPopup: true,
      showJournalNotification: false,
    );
  }

  void showGrammarPopup() {
    state = state.copyWith(
      showGrammarPopup: true,
      showJournalNotification: false,
    );
  }

  void showCulturalNotePopup() {
    state = state.copyWith(
      showCulturalNotePopup: true,
      showJournalNotification: false,
    );
  }

  void toggleAutoMode() {
    final newAutoMode = !state.isAutoMode;
    state = state.copyWith(
      isAutoMode: newAutoMode,
      isSkipping: false,
    );

    if (newAutoMode) {
      _startAutoMode();
    } else {
      _autoModeTimer?.cancel();
    }
  }

  void _startAutoMode() {
    final settings = ref.read(gameplaySettingsProvider);
    final autoDelay = settings['autoplayDelay'] as int? ?? 2000;

    _autoModeTimer?.cancel();
    _autoModeTimer = Timer.periodic(
      Duration(milliseconds: autoDelay),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        // Auto advance logic would be handled by the screen
      },
    );
  }

  void toggleSkipMode() {
    ref.read(soundControllerProvider.notifier).playClick();
    final newSkipping = !state.isSkipping;
    state = state.copyWith(
      isSkipping: newSkipping,
      isAutoMode: false,
    );

    if (newSkipping) {
      _startSkipping();
    } else {
      _autoModeTimer?.cancel();
    }
  }

  void _startSkipping() {
    _autoModeTimer?.cancel();
    _autoModeTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        // Skip logic would be handled by the screen
      },
    );
  }

  void setTextComplete(bool complete) {
    state = state.copyWith(isTextComplete: complete);
  }

  void showDialogueChoices() {
    state = state.copyWith(showChoices: true);
  }

  void hideChoices() {
    state = state.copyWith(showChoices: false, isTextComplete: false);
  }

  Future<void> updateCharacterSprites(DialogueLine? currentLine, BuildContext context) async {
    if (currentLine == null) return;

    if (currentLine.background != null && currentLine.background != state.currentBackground) {
      state = state.copyWith(currentBackground: currentLine.background!);
      await captureBackgroundScreenshot(context);
    }

    final sprites = <Widget>[];
    if (currentLine.characterId != null && currentLine.sprite != null) {
      final character = state.characters[currentLine.characterId];
      final position = currentLine.position ?? 'center';

      if (character != null) {
        sprites.add(
          CharacterSprite(
            character: character,
            expression: currentLine.sprite!,
            position: position,
            isSpeaking: true,
            key: ValueKey('${character.id}_${currentLine.sprite}'),
          ),
        );
      }
    }

    state = state.copyWith(characterSprites: sprites);

    if (sprites.isNotEmpty) {
      await captureBackgroundScreenshot(context);
    }
  }

  Future<String?> captureScreenshot(BuildContext context, {bool forSaving = false}) async {
    if (state.isCapturingScreenshot ||
        state.isMenuOpen ||
        state.showVocabPopup ||
        state.showGrammarPopup ||
        state.showCulturalNotePopup ||
        state.isSceneTransitioning ||
        state.isChapterTransitioning) {
      return null;
    }

    state = state.copyWith(isCapturingScreenshot: true);

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final activeSaveId = ref.read(activeSaveIdProvider);
      final fileName = 'save_$activeSaveId';

      final screenshotPath = await ScreenshotHelper.takeAndSaveScreenshot(
        controller: screenshotController,
        fileName: fileName,
      );

      if (screenshotPath != null) {
        final size = MediaQuery.sizeOf(context);
        final thumbnailPath = await ScreenshotHelper.generateThumbnail(
          screenshotPath: screenshotPath,
          thumbnailName: 'thumb_$fileName',
          width: (size.width * 0.5).toInt(),
          height: (size.height * 0.5).toInt(),
        );

        return thumbnailPath;
      }
    } catch (e, stack) {
      AppLogger.error('Error capturing screenshot', error: e, stackTrace: stack);
    } finally {
      state = state.copyWith(isCapturingScreenshot: false);
    }

    return null;
  }

  Future<void> captureBackgroundScreenshot(BuildContext context) async {
    final now = DateTime.now();
    if (_lastScreenshotTime != null && now.difference(_lastScreenshotTime!).inSeconds < 5) {
      return;
    }

    _lastScreenshotTime = now;

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final path = await captureScreenshot(context);
      final activeSaveId = ref.read(activeSaveIdProvider);
      if (path != null && activeSaveId != null) {
        final gameRepository = ref.read(gameRepositoryProvider);
        await gameRepository.createQuickSave(currentSaveId: activeSaveId, thumbnailPath: path);
      }
    } catch (e, stack) {
      AppLogger.error('Error capturing background screenshot', error: e, stackTrace: stack);
    }
  }

  Future<void> checkAndUnlockCharacter(DialogueLine? line) async {
    if (line?.characterId == null) return;

    final characterId = int.tryParse(line!.characterId!);
    if (characterId == null) return;

    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      try {
        final result = await gameRepository.unlockCharacter(activeSaveId, characterId);
        if (result) {
          AppLogger.info('Unlocked new character with ID $characterId');
        }
      } catch (e, stack) {
        AppLogger.error('Error unlocking character', error: e, stackTrace: stack);
      }
    }
  }

  Future<void> checkForLearningMoments(DialogueLine? currentLine) async {
    if (currentLine == null) return;

    if (currentLine.vocabularyIds.isNotEmpty) {
      await _unlockVocabularyItems(currentLine.vocabularyIds);
    }

    if (currentLine.grammarIds.isNotEmpty) {
      await _unlockGrammarPoints(currentLine.grammarIds);
    }

    if (currentLine.culturalNoteIds.isNotEmpty) {
      await _unlockCulturalNotes(currentLine.culturalNoteIds);
    }
  }

  Future<void> _unlockVocabularyItems(List<String> vocabIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);
    if (activeSaveId == null) return;

    try {
      for (final id in vocabIds) {
        final vocabId = int.tryParse(id);
        if (vocabId != null) {
          await gameRepository.unlockVocabulary(activeSaveId, vocabId);
        }
      }
    } catch (e, stack) {
      AppLogger.error('Error unlocking vocabulary', error: e, stackTrace: stack);
    }
  }

  Future<void> _unlockGrammarPoints(List<String> grammarIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);
    if (activeSaveId == null) return;

    try {
      for (final id in grammarIds) {
        final grammarId = int.tryParse(id);
        if (grammarId != null) {
          await gameRepository.unlockGrammar(activeSaveId, grammarId);
        }
      }
    } catch (e, stack) {
      AppLogger.error('Error unlocking grammar points', error: e, stackTrace: stack);
    }
  }

  Future<void> _unlockCulturalNotes(List<String> noteIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);
    if (activeSaveId == null) return;

    try {
      for (final id in noteIds) {
        final noteId = int.tryParse(id);
        if (noteId != null) {
          await gameRepository.unlockCulturalNote(activeSaveId, noteId);
        }
      }
    } catch (e, stack) {
      AppLogger.error('Error unlocking cultural notes', error: e, stackTrace: stack);
    }
  }

  void startSceneTransition() {
    state = state.copyWith(isSceneTransitioning: true);
  }

  void endSceneTransition() {
    state = state.copyWith(
      isSceneTransitioning: false,
      characterSprites: [],
      currentBackground: '',
    );
  }

  void startChapterTransition(String chapterTitle) {
    state = state.copyWith(
      isChapterTransitioning: true,
      nextChapterTitle: chapterTitle,
    );
  }

  void endChapterTransition() {
    state = state.copyWith(
      isChapterTransitioning: false,
      nextChapterTitle: '',
      characterSprites: [],
      currentBackground: '',
    );
  }

  @override
  void dispose() {
    _autoModeTimer?.cancel();
    _playTimeTimer?.cancel();
    super.dispose();
  }
}

final gameScreenControllerProvider = StateNotifierProvider.autoDispose<GameScreenController, GameScreenState>((ref) {
  final controller = ScreenshotController();
  return GameScreenController(ref, controller);
});
