import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/dialogue_line.dart';
import '../../models/vocab_word.dart';
import '../../novel/vocabulary_lessons/vocabulary_lessons.dart';
import '../../services/access_policy.dart';
import '../../services/audio_service.dart';
import '../../services/character_assets.dart';
import '../../services/content_service.dart';
import '../../services/i18n_service.dart';
import '../../services/tts_service.dart';
import '../../services/vocab_matcher.dart';
import '../../state/analytics_provider.dart';
import '../../state/i18n_provider.dart';
import '../../state/in_app_review_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/scene_player_provider.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/scene_background.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/game_notification.dart';
import '../../widgets/glass_panel.dart';
import '../../widgets/vocab_popup.dart';
import '../settings/settings_screen.dart';
import '../vocab_log/vocab_log_screen.dart';

const double _kGameAspect = 1920 / 1080;

Rect _gameLayerCoverRect(Size box) {
  final boxAspect = box.width / box.height;
  double width, height;
  if (boxAspect > _kGameAspect) {
    width = box.width;
    height = width / _kGameAspect;
  } else {
    height = box.height;
    width = height * _kGameAspect;
  }
  return Rect.fromLTWH(
    (box.width - width) / 2,
    (box.height - height) / 2,
    width,
    height,
  );
}

class DialogueScreen extends ConsumerStatefulWidget {
  const DialogueScreen({
    super.key,
    required this.category,
    required this.storyId,
    this.initialSave,
  });

  final ContentCategory category;
  final String storyId;
  final Map<String, dynamic>? initialSave;

  @override
  ConsumerState<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends ConsumerState<DialogueScreen> {
  bool _progressMarked = false;
  bool _continuingToNext = false;

  bool _leavingForAnotherStory = false;
  late bool _translationVisible;
  late Future<List<VocabWord>> _vocabFuture;
  bool _autoAdvanceEnabled = false;
  Timer? _autoAdvanceTimer;
  String? _scheduledAutoLine;
  String? _typingCompleteLine;
  final List<_DialogueLogEntry> _dialogueLog = [];
  final Set<String> _loggedLineKeys = {};
  final Object _audioOwner = Object();
  late AudioService _audioService;
  // late TypingSoundService _typingSoundService;
  String? _playingMusicTrack;

  String? _highlightedCharacter;

  @override
  void initState() {
    super.initState();
    _audioService = ref.read(audioServiceProvider);
    // _typingSoundService = ref.read(typingSoundServiceProvider);
    _translationVisible = ref.read(settingsProvider).showSubtitles;
    _vocabFuture = ref.read(contentServiceProvider).loadVocabulary();
    ref.read(analyticsProvider).logEvent('dialogue_start', {
      'category': widget.category.name,
      'story_id': widget.storyId,
    });
    _loadStory();
  }

  void _loadStory() {
    Future.microtask(() async {
      final notifier = ref.read(scenePlayerProvider.notifier);
      final initialSave = widget.initialSave;
      if (initialSave == null) {
        await notifier.loadStory(widget.category, widget.storyId);
      } else {
        await notifier.restoreStory(
          widget.category,
          widget.storyId,
          initialSave,
        );
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    unawaited(_audioService.ensureMusicPlaying());
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    if (_leavingForAnotherStory) {
      unawaited(_audioService.stopMusic(owner: _audioOwner));
    } else {
      unawaited(_audioService.fadeToMenuMusic(owner: _audioOwner));
    }
    super.dispose();
  }

  bool _firstMusicSync = true;

  void _syncMusic(String? track) {
    if (_playingMusicTrack == track) return;
    _playingMusicTrack = track;
    final isFirst = _firstMusicSync;
    _firstMusicSync = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _playingMusicTrack != track) return;
      if (isFirst) {
        unawaited(_audioService.fadeToGameMusic(track, owner: _audioOwner));
      } else {
        unawaited(_audioService.playMusic(track, owner: _audioOwner));
      }
    });
  }

  void _resumeMusicFromGesture() {
    final track = ref.read(scenePlayerProvider).currentMusic;
    if (track != null) {
      unawaited(_audioService.playMusic(track, owner: _audioOwner));
    }
  }

  void _markProgressComplete() {
    if (_progressMarked) return;
    _progressMarked = true;
    ref.read(analyticsProvider).logEvent('dialogue_complete', {
      'category': widget.category.name,
      'story_id': widget.storyId,
    });
    final notifier = ref.read(progressProvider.notifier);
    final progress = ref.read(progressProvider);
    var firstCompletion = false;
    switch (widget.category) {
      case ContentCategory.lesson:
        firstCompletion = !progress.completedLessons.contains(widget.storyId);
        notifier.markLessonComplete(widget.storyId);
      case ContentCategory.vocabLesson:
        firstCompletion = !progress.completedVocabLessons.contains(
          widget.storyId,
        );
        notifier.markVocabLessonComplete(widget.storyId);
        final lesson = vocabularyLessonById[widget.storyId];
        if (lesson != null) notifier.markWordsLearned(lesson.wordIds);
      case ContentCategory.chapter:
        notifier.markStoryComplete(widget.storyId);
    }
    // Replaying a finished lesson doesn't count towards the review prompt.
    if (firstCompletion) _askForReviewAfterLesson();
  }

  /// Counts the finished lesson and, once the player has completed enough of
  /// them (the second or third), shows the store review prompt after a short
  /// pause so it doesn't cover the lesson's final line.
  void _askForReviewAfterLesson() {
    final review = ref.read(inAppReviewProvider);
    unawaited(
      Future<void>.delayed(
        const Duration(seconds: 2),
        review.onLessonCompleted,
      ),
    );
  }

  void _retry() {
    _autoAdvanceTimer?.cancel();
    setState(() {
      _progressMarked = false;
      _autoAdvanceEnabled = false;
      _scheduledAutoLine = null;
      _typingCompleteLine = null;
      _dialogueLog.clear();
      _loggedLineKeys.clear();
    });
    _loadStory();
  }

  bool _isPaidCatalogEntry(
    String id,
    List<String> order,
    Map<String, dynamic> entry,
  ) {
    return switch (widget.category) {
      ContentCategory.lesson => AccessPolicy.isLessonPaidTier(id, order),
      ContentCategory.vocabLesson => AccessPolicy.isVocabLessonPaidTier(
        id,
        order,
      ),
      ContentCategory.chapter => AccessPolicy.isStoryPaidTier(
        entry['cefrFocus'] as String?,
      ),
    };
  }

  Future<void> _continueToNext(I18nService i18n) async {
    if (_continuingToNext) return;
    setState(() => _continuingToNext = true);

    try {
      if (widget.category == ContentCategory.chapter &&
          widget.storyId == 'story0') {
        final pendingTrack = ref
            .read(progressProvider.notifier)
            .consumePendingOnboardingTrack();
        if (pendingTrack != null && mounted) {
          final settings = ref.read(settingsProvider);
          final progressNotifier = ref.read(progressProvider.notifier);
          _leavingForAnotherStory = true;
          if (pendingTrack == 'lesson') {
            progressNotifier.markLessonModeStarted();
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => DialogueScreen(
                  category: ContentCategory.lesson,
                  storyId: AccessPolicy.firstLessonIdForLevel(
                    settings.playerLevel,
                  ),
                ),
              ),
            );
          } else if (pendingTrack == 'vocab-lesson') {
            progressNotifier.markVocabModeStarted();
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => DialogueScreen(
                  category: ContentCategory.vocabLesson,
                  storyId: AccessPolicy.firstVocabLessonIdForLevel(
                    settings.playerLevel,
                  ),
                ),
              ),
            );
          }
          return;
        }
      }

      final catalog = await ref
          .read(contentServiceProvider)
          .loadCatalog(widget.category);
      final order = catalog.map((entry) => entry['id'] as String).toList();
      final currentIndex = order.indexOf(widget.storyId);
      if (!mounted) return;

      if (currentIndex < 0 || currentIndex + 1 >= catalog.length) {
        Navigator.of(context).pop();
        return;
      }

      final nextEntry = catalog[currentIndex + 1];
      final nextId = nextEntry['id'] as String;
      final isPaidTier = _isPaidCatalogEntry(nextId, order, nextEntry);
      final accessible = AccessPolicy.isAccessible(
        isPaidTier: isPaidTier,
        hasPremium: ref.read(progressProvider).isPremium,
      );
      if (!accessible) {
        showGameNotification(
          context,
          message: i18n.t('runtime.iap.premium_badge'),
          type: GameNotificationType.warning,
        );
        return;
      }

      _leavingForAnotherStory = true;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              DialogueScreen(category: widget.category, storyId: nextId),
        ),
      );
    } catch (_) {
      if (mounted) {
        final invalidKey = switch (widget.category) {
          ContentCategory.lesson => 'runtime.lesson_select.invalid',
          ContentCategory.vocabLesson => 'runtime.vocab_select.invalid',
          ContentCategory.chapter => 'runtime.chapter_select.invalid',
        };
        showGameNotification(
          context,
          message: i18n.t(invalidKey),
          type: GameNotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _continuingToNext = false);
    }
  }

  void _toggleAutoAdvance() {
    setState(() {
      _autoAdvanceEnabled = !_autoAdvanceEnabled;
      _scheduledAutoLine = null;
    });
    if (!_autoAdvanceEnabled) _autoAdvanceTimer?.cancel();
  }

  void _syncAutoAdvance(ScenePlayerState state) {
    final scene = state.currentScene;
    final line = state.currentLine;
    final lineKey = scene == null ? null : '${scene.id}:${state.lineIndex}';
    final canAdvance =
        _autoAdvanceEnabled &&
        state.status == PlayerStatus.line &&
        line is! TitleCardLine &&
        lineKey != null &&
        _typingCompleteLine == lineKey;

    if (!canAdvance) {
      _autoAdvanceTimer?.cancel();
      _scheduledAutoLine = null;
      return;
    }
    if (_scheduledAutoLine == lineKey) return;

    _autoAdvanceTimer?.cancel();
    _scheduledAutoLine = lineKey;
    // Typewriter completion is part of [canAdvance], so this delay starts
    // only after the whole sentence has appeared (naturally or after a tap).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_autoAdvanceEnabled || _scheduledAutoLine != lineKey) {
        return;
      }
      _autoAdvanceTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted || !_autoAdvanceEnabled) return;
        final latest = ref.read(scenePlayerProvider);
        final latestKey = latest.currentScene == null
            ? null
            : '${latest.currentScene!.id}:${latest.lineIndex}';
        if (latestKey == lineKey && latest.status == PlayerStatus.line) {
          ref.read(scenePlayerProvider.notifier).advance();
        }
      });
    });
  }

  void _onTypingComplete(String lineKey) {
    if (!mounted || _typingCompleteLine == lineKey) return;
    final current = ref.read(scenePlayerProvider);
    final currentKey = current.currentScene == null
        ? null
        : '${current.currentScene!.id}:${current.lineIndex}';
    if (currentKey != lineKey) return;
    setState(() {
      _typingCompleteLine = lineKey;
      _scheduledAutoLine = null;
    });
  }

  void _recordDialogueLine(ScenePlayerState state) {
    final scene = state.currentScene;
    final line = state.currentLine;
    if (scene == null || line == null) return;
    final (speaker, textKey) = switch (line) {
      DialogueTextLine(speaker: final speaker, text: final text) => (
        speaker,
        text,
      ),
      NarrationLine(text: final text) => (null, text),
      _ => (null, null),
    };
    if (textKey == null) return;
    final key = '${scene.id}:${state.lineIndex}';
    if (!_loggedLineKeys.add(key)) return;
    _dialogueLog.add(_DialogueLogEntry(speaker: speaker, textKey: textKey));
  }

  Future<void> _quickSave(I18nService i18n) async {
    final snapshot = ref.read(scenePlayerProvider.notifier).createSnapshot();
    if (snapshot == null) return;
    await ref.read(saveServiceProvider).saveAutosave({
      'category': widget.category.name,
      'storyId': widget.storyId,
      'savedAt': DateTime.now().toIso8601String(),
      'snapshot': snapshot,
    });
    if (!mounted) return;
    showGameNotification(
      context,
      message: i18n.t('runtime.saved'),
      type: GameNotificationType.success,
    );
  }

  Future<void> _loadQuickSave(I18nService i18n) async {
    final save = ref.read(saveServiceProvider).autosave;
    final storyId = save?['storyId'] as String?;
    final categoryName = save?['category'] as String?;
    final snapshotJson = save?['snapshot'];
    if (storyId == null || categoryName == null || snapshotJson is! Map) {
      if (mounted) {
        showGameNotification(
          context,
          message: i18n.t('runtime.save.empty'),
          type: GameNotificationType.warning,
        );
      }
      return;
    }
    final category = ContentCategory.values
        .where((value) => value.name == categoryName)
        .firstOrNull;
    if (category == null) return;
    final snapshot = Map<String, dynamic>.from(snapshotJson);

    _autoAdvanceTimer?.cancel();
    if (category == widget.category && storyId == widget.storyId) {
      final restored = await ref
          .read(scenePlayerProvider.notifier)
          .restoreStory(category, storyId, snapshot);
      if (restored && mounted) {
        setState(() {
          _autoAdvanceEnabled = false;
          _scheduledAutoLine = null;
          _dialogueLog.clear();
          _loggedLineKeys.clear();
        });
      }
      return;
    }

    if (!mounted) return;
    _leavingForAnotherStory = true;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DialogueScreen(
          category: category,
          storyId: storyId,
          initialSave: snapshot,
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context, I18nService i18n) async {
    _autoAdvanceTimer?.cancel();
    _scheduledAutoLine = null;
    final confirmed = await showConfirmDialog(
      context,
      message: i18n.t('runtime.confirm.return_to_title'),
      i18n: i18n,
    );
    if (confirmed && context.mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      setState(() => _scheduledAutoLine = null);
    }
  }

  Future<T?> _showPausedModal<T>(WidgetBuilder builder) async {
    _autoAdvanceTimer?.cancel();
    _scheduledAutoLine = null;
    final result = await showAdaptiveModal<T>(
      context: context,
      builder: builder,
    );
    if (mounted) setState(() => _scheduledAutoLine = null);
    return result;
  }

  Future<void> _showDialogueLog(I18nService i18n) async {
    await _showPausedModal<void>(
      (_) => _DialogueLogModal(
        entries: List.unmodifiable(_dialogueLog),
        i18n: i18n,
      ),
    );
  }

  Future<void> _showQuickMenu(I18nService i18n) async {
    final hasSave = ref.read(saveServiceProvider).autosave != null;
    await _showPausedModal<void>(
      (_) => _QuickMenuModal(
        i18n: i18n,
        hasSave: hasSave,
        onSave: () => _quickSave(i18n),
        onLoad: () => _loadQuickSave(i18n),
        onTextLog: () => _showDialogueLog(i18n),
        onVocabLog: () => _showPausedModal<void>((_) => const VocabLogScreen()),
        onSettings: () => _showPausedModal<void>((_) => const SettingsScreen()),
        onMainMenu: () => _confirmExit(context, i18n),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scenePlayerProvider);
    final i18n = ref.watch(i18nProvider);
    final settings = ref.watch(settingsProvider);
    final ttsService = ref.read(ttsServiceProvider);
    final size = MediaQuery.sizeOf(context);

    _recordDialogueLine(state);
    _syncAutoAdvance(state);
    _syncMusic(state.currentMusic);

    if (state.status == PlayerStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.status == PlayerStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _markProgressComplete(),
      );
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final coverRect = _gameLayerCoverRect(
                  Size(constraints.maxWidth, constraints.maxHeight),
                );

                final speakerOnly =
                    constraints.maxWidth <= 1180 &&
                    constraints.maxHeight > constraints.maxWidth;
                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fromRect(
                      rect: coverRect,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: _backgroundColor(state.background)),
                          SceneBackground(
                            backgroundId: state.background,
                            time: state.backgroundTime,
                          ),
                        ],
                      ),
                    ),
                    ..._buildCharacters(
                      state,
                      coverRect,
                      Size(constraints.maxWidth, constraints.maxHeight),
                      speakerOnly,
                    ),
                  ],
                );
              },
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: GlassPanel(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            i18n.t('runtime.story_complete.title'),
                            style: AppTheme.englishFont(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            i18n.t('runtime.story_complete.praise'),
                            style: const TextStyle(color: AppColors.brownDark),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _retry,
                                  child: Text(
                                    i18n.t('runtime.story_complete.retry'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.orange,
                                  ),
                                  onPressed: _continuingToNext
                                      ? null
                                      : () => _continueToNext(i18n),
                                  child: _continuingToNext
                                      ? const SizedBox.square(
                                          dimension: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          i18n.t(
                                            'runtime.story_complete.continue',
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final currentLine = state.currentLine;
    if (currentLine is DialogueTextLine &&
        currentLine.speaker.toLowerCase() != 'player') {
      _highlightedCharacter = currentLine.speaker;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resumeMusicFromGesture(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await _confirmExit(context, i18n);
        },
        child: Scaffold(
          body: currentLine is TitleCardLine
              ? _StoryTitleCard(
                  titleCard: currentLine,
                  i18n: i18n,
                  onAdvance: () =>
                      ref.read(scenePlayerProvider.notifier).advance(),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final coverRect = _gameLayerCoverRect(
                          Size(constraints.maxWidth, constraints.maxHeight),
                        );
                        final speakerOnly =
                            constraints.maxWidth <= 1180 &&
                            constraints.maxHeight > constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Positioned.fromRect(
                              rect: coverRect,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: _backgroundColor(state.background),
                                  ),
                                  SceneBackground(
                                    backgroundId: state.background,
                                    time: state.backgroundTime,
                                  ),
                                ],
                              ),
                            ),
                            ..._buildCharacters(
                              state,
                              coverRect,
                              Size(constraints.maxWidth, constraints.maxHeight),
                              speakerOnly,
                            ),
                          ],
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final isChoice = state.status == PlayerStatus.choice;
                        final lineKey = state.currentScene == null
                            ? ''
                            : '${state.currentScene!.id}:${state.lineIndex}';
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: isChoice ? 0 : null,
                          child: SafeArea(
                            child: isChoice
                                ? _ChoicePanel(
                                    choices: (state.currentLine as ChoiceLine)
                                        .choices,
                                    i18n: i18n,
                                    japaneseFirst:
                                        widget.category ==
                                        ContentCategory.vocabLesson,
                                    showTranslation:
                                        settings.showChoiceTranslation,
                                    uiLanguage: settings.language,
                                    onSelect: (c) => ref
                                        .read(scenePlayerProvider.notifier)
                                        .selectChoice(c),
                                  )
                                : _DialogueBox(
                                    key: ValueKey(lineKey),
                                    line: state.currentLine!,
                                    i18n: i18n,
                                    uiLanguage: settings.language,
                                    playerLevel: settings.playerLevel,
                                    translationVisible: _translationVisible,
                                    vocabFuture: _vocabFuture,
                                    ttsService: ttsService,
                                    // typingSoundService: _typingSoundService,
                                    onTap: () => ref
                                        .read(scenePlayerProvider.notifier)
                                        .advance(),
                                    onTypingComplete: () =>
                                        _onTypingComplete(lineKey),
                                    onWordTap: (word) => ref
                                        .read(progressProvider.notifier)
                                        .markWordLearned(word.id),
                                    onToggleTranslation: () => setState(
                                      () => _translationVisible =
                                          !_translationVisible,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GlassPanel(
                            borderRadius: AppRadii.pill,
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: [
                                _CircleIconButton(
                                  icon: Icons.settings_outlined,
                                  tooltip: i18n.t('settings.title'),
                                  onTap: () => _showPausedModal<void>(
                                    (_) => const SettingsScreen(),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                _CircleIconButton(
                                  icon: Icons.navigate_next_rounded,
                                  tooltip: i18n.t('game.auto'),
                                  active: _autoAdvanceEnabled,
                                  onTap: _toggleAutoAdvance,
                                ),
                                const SizedBox(width: 4),
                                _CircleIconButton(
                                  icon: Icons.menu,
                                  tooltip: i18n.t('game.menu'),
                                  onTap: () => _showQuickMenu(i18n),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (size.width > 700 && size.height > 500)
                      Positioned(
                        right: 24,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _SideIconMenu(
                            onLog: () => _showDialogueLog(i18n),
                            onVocab: () => _showPausedModal<void>(
                              (_) => const VocabLogScreen(),
                            ),
                            onQuickSave: () => _quickSave(i18n),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  static const _positions = {
    'far-left': 0.15,
    'left': 0.25,
    'center': 0.5,
    'right': 0.75,
    'far-right': 0.85,
  };

  static const _visibleFraction = 0.55;
  static const _heightInflate = 1.05;

  static const _dimAlpha = 0.65;

  List<Widget> _buildCharacters(
    ScenePlayerState state,
    Rect coverRect,
    Size viewportSize,
    bool speakerOnlyMode,
  ) {
    final boxSize = coverRect.size;
    final viewportWidth = viewportSize.width;
    final entries = state.characters.entries.toList();

    final highlightedKey = _highlightedCharacter?.toLowerCase();
    String? matchedActiveId;
    for (final entry in entries) {
      if (entry.key.toLowerCase() == highlightedKey &&
          CharacterAssets.path(entry.key, entry.value.expression) != null) {
        matchedActiveId = entry.key;
        break;
      }
    }

    String? portraitActiveId = matchedActiveId;
    if (speakerOnlyMode && portraitActiveId == null) {
      for (final entry in entries.reversed) {
        if (CharacterAssets.path(entry.key, entry.value.expression) != null) {
          portraitActiveId = entry.key;
          break;
        }
      }
    }
    final activeId = speakerOnlyMode ? portraitActiveId : matchedActiveId;

    final speakerOnly = speakerOnlyMode && activeId != null;

    bool isHidden(MapEntry<String, CharacterView> entry) {
      if (speakerOnly && entry.key != activeId) return true;
      if (entry.key == activeId) return false;
      return entries.any(
        (other) =>
            other.key == activeId &&
            other.value.position == entry.value.position,
      );
    }

    final visibleEntries =
        entries
            .where(
              (entry) =>
                  !isHidden(entry) &&
                  CharacterAssets.path(entry.key, entry.value.expression) !=
                      null,
            )
            .toList()
          ..sort(
            (a, b) => (_positions[a.value.position] ?? 0.5).compareTo(
              _positions[b.value.position] ?? 0.5,
            ),
          );
    final naturalWidths = <String, double>{
      for (final entry in visibleEntries)
        entry.key:
            boxSize.height *
            CharacterAssets.heightRatio(entry.key) *
            _heightInflate /
            _visibleFraction *
            CharacterAssets.aspectRatio(entry.key),
    };
    final gap = visibleEntries.length > 1
        ? (viewportWidth / (visibleEntries.length * 4)).clamp(0.0, 24.0)
        : 0.0;
    final naturalWidth = naturalWidths.values.fold<double>(
      0,
      (sum, width) => sum + width,
    );
    final availableWidth = (viewportWidth - gap * (visibleEntries.length - 1))
        .clamp(0.0, viewportWidth);
    final layoutScale = naturalWidth > availableWidth && naturalWidth > 0
        ? availableWidth / naturalWidth
        : 1.0;
    final centers = _characterCenters(
      visibleEntries,
      Size(viewportWidth, boxSize.height),
      layoutScale: layoutScale,
      gap: gap,
    );

    entries.sort((a, b) {
      final distA = ((_positions[a.value.position] ?? 0.5) - 0.5).abs();
      final distB = ((_positions[b.value.position] ?? 0.5) - 0.5).abs();
      return distB.compareTo(distA);
    });

    return entries.map((entry) {
      final id = entry.key;
      final view = entry.value;
      final isSpeaker = id == activeId;
      final hidden = isHidden(entry);
      final dimmed = !hidden && activeId != null && !isSpeaker;

      final path = CharacterAssets.path(id, view.expression);
      final align = speakerOnly && isSpeaker
          ? 0.5
          : (_positions[view.position] ?? 0.5);
      final scaledVisibleHeight =
          boxSize.height *
          CharacterAssets.heightRatio(id) *
          _heightInflate *
          layoutScale;
      final scaledFullSpriteHeight = scaledVisibleHeight / _visibleFraction;
      final scaledSpriteWidth =
          scaledFullSpriteHeight * CharacterAssets.aspectRatio(id);
      final viewportScale =
          scaledSpriteWidth > viewportWidth && scaledSpriteWidth > 0
          ? viewportWidth / scaledSpriteWidth
          : 1.0;
      final visibleHeight = scaledVisibleHeight * viewportScale;
      final fullSpriteHeight = scaledFullSpriteHeight * viewportScale;
      final spriteWidth = (scaledSpriteWidth * viewportScale).clamp(
        0.0,
        viewportWidth,
      );
      final desiredCenter = speakerOnly && isSpeaker
          ? viewportWidth / 2
          : (centers[id] ?? align * viewportWidth);
      final minCenter = spriteWidth / 2;
      final maxCenter = viewportWidth - spriteWidth / 2;
      final center = minCenter <= maxCenter
          ? desiredCenter.clamp(minCenter, maxCenter)
          : viewportWidth / 2;
      final maxLeft = (viewportWidth - spriteWidth).clamp(0.0, viewportWidth);
      final left = (center - spriteWidth / 2).clamp(0.0, maxLeft);

      return AnimatedPositioned(
        key: ValueKey(id),
        duration: const Duration(milliseconds: 250),
        left: left,
        width: spriteWidth,
        top: coverRect.top + boxSize.height - visibleHeight,
        height: visibleHeight,
        child: (path == null || hidden)
            ? const SizedBox.shrink()
            : ClipRect(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: dimmed ? _dimAlpha : 1.0,

                  child: OverflowBox(
                    minWidth: spriteWidth,
                    maxWidth: spriteWidth,
                    minHeight: fullSpriteHeight,
                    maxHeight: fullSpriteHeight,
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Image.asset(
                        path,
                        key: ValueKey(path),
                        width: spriteWidth,
                        height: fullSpriteHeight,
                        fit: BoxFit.fill,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
      );
    }).toList();
  }

  Map<String, double> _characterCenters(
    List<MapEntry<String, CharacterView>> entries,
    Size boxSize, {
    required double layoutScale,
    required double gap,
  }) {
    if (entries.isEmpty) return const {};
    if (entries.length == 1) {
      final entry = entries.single;
      final anchor = (_positions[entry.value.position] ?? 0.5) * boxSize.width;
      final naturalWidth =
          boxSize.height *
          CharacterAssets.heightRatio(entry.key) *
          _heightInflate /
          _visibleFraction *
          CharacterAssets.aspectRatio(entry.key) *
          layoutScale;
      final width = naturalWidth.clamp(0.0, boxSize.width);
      return {entry.key: anchor.clamp(width / 2, boxSize.width - width / 2)};
    }

    final widths = <double>[
      for (final entry in entries)
        (boxSize.height *
                CharacterAssets.heightRatio(entry.key) *
                _heightInflate /
                _visibleFraction *
                CharacterAssets.aspectRatio(entry.key) *
                layoutScale)
            .clamp(0.0, boxSize.width),
    ];
    final centers = [
      for (final entry in entries)
        (_positions[entry.value.position] ?? 0.5) * boxSize.width,
    ];

    for (var i = 0; i < centers.length; i++) {
      centers[i] = centers[i].clamp(
        widths[i] / 2,
        boxSize.width - widths[i] / 2,
      );
      if (i > 0) {
        final minimum = centers[i - 1] + (widths[i - 1] + widths[i]) / 2 + gap;
        if (centers[i] < minimum) centers[i] = minimum;
      }
    }

    final rightOverflow = centers.last + widths.last / 2 - boxSize.width;
    if (rightOverflow > 0) {
      for (var i = 0; i < centers.length; i++) {
        centers[i] -= rightOverflow;
      }
    }
    for (var i = centers.length - 2; i >= 0; i--) {
      final maximum = centers[i + 1] - (widths[i + 1] + widths[i]) / 2 - gap;
      if (centers[i] > maximum) centers[i] = maximum;
    }

    final leftOverflow = widths.first / 2 - centers.first;
    if (leftOverflow > 0) {
      for (var i = 0; i < centers.length; i++) {
        centers[i] += leftOverflow;
      }
    }

    return {
      for (var i = 0; i < entries.length; i++) entries[i].key: centers[i],
    };
  }

  Color _backgroundColor(String? bg) {
    const colors = {
      'classroom': Color(0xFFFCEBD6),
      'hallway': Color(0xFFF3E3D3),
      'street': Color(0xFFD9E4E8),
      'cafe': Color(0xFFF0DCC8),
      'izakaya': Color(0xFF3A2E28),
      'station': Color(0xFFDCE2E8),
      'park': Color(0xFFDCEBDC),
      'apartment': Color(0xFFF5EAE0),
      'train': Color(0xFFE2E7EC),
      'bathroom': Color(0xFFE6F0EE),
      'bedroom': Color(0xFFEDE3F0),
      'laundromat': Color(0xFFE8ECF2),
      'livingroom': Color(0xFFF2E9DD),
    };
    return colors[bg] ?? AppColors.cream;
  }
}

class _StoryTitleCard extends StatefulWidget {
  const _StoryTitleCard({
    required this.titleCard,
    required this.i18n,
    required this.onAdvance,
  });

  final TitleCardLine titleCard;
  final I18nService i18n;
  final VoidCallback onAdvance;

  @override
  State<_StoryTitleCard> createState() => _StoryTitleCardState();
}

class _StoryTitleCardState extends State<_StoryTitleCard> {
  bool _visible = false;
  Timer? _holdTimer;
  Timer? _advanceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    _holdTimer = Timer(Duration(milliseconds: widget.titleCard.duration), () {
      if (!mounted) return;
      setState(() => _visible = false);
      _advanceTimer = Timer(
        const Duration(milliseconds: 300),
        widget.onAdvance,
      );
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.i18n.t(widget.titleCard.title),
              textAlign: TextAlign.center,
              style: AppTheme.englishFont(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.purpleDark,
              ).copyWith(letterSpacing: 0.8, decoration: TextDecoration.none),
            ),
            if (widget.titleCard.subtitle.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                widget.i18n.t(widget.titleCard.subtitle),
                textAlign: TextAlign.center,
                style: AppTheme.japaneseFont(
                  fontSize: 22,
                  color: AppColors.brownDark,
                ).copyWith(decoration: TextDecoration.none),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        selected: active,
        label: tooltip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active ? AppColors.primaryButtonGradient : null,
            boxShadow: active ? AppShadows.primaryButton : const [],
          ),
          child: Material(
            color: active ? Colors.transparent : AppColors.glassBgStrong,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  icon,
                  color: active
                      ? AppColors.primaryButtonText
                      : AppColors.brownDark,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SideIconMenu extends ConsumerWidget {
  const _SideIconMenu({
    required this.onLog,
    required this.onVocab,
    required this.onQuickSave,
  });

  final VoidCallback onLog;
  final VoidCallback onVocab;
  final VoidCallback onQuickSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = ref.watch(i18nProvider);
    // `.side-icon-menu` — one glass pill wrapping all three buttons.
    return GlassPanel(
      borderRadius: 28,
      color: AppColors.glassBgSoft,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SideIconButton(
            icon: Icons.assignment_outlined,
            label: i18n.t('game.log'),
            bubbleColor: const Color(0x296F52B5), // rgba(111,82,181,0.16)
            iconColor: AppColors.purpleDark,
            onTap: onLog,
          ),
          const SizedBox(height: 14),
          _SideIconButton(
            icon: Icons.menu_book_outlined,
            label: i18n.t('game.vocab'),
            bubbleColor: const Color(0x33E8946F), // rgba(232,148,111,0.2)
            iconColor: const Color(0xFFC9663A),
            onTap: onVocab,
          ),
          const SizedBox(height: 14),
          _SideIconButton(
            icon: Icons.save_outlined,
            label: i18n.t('game.quick_save'),
            bubbleColor: const Color(0x408FB49F), // rgba(143,180,159,0.25)
            iconColor: AppColors.greenDark,
            onTap: onQuickSave,
          ),
        ],
      ),
    );
  }
}

class _SideIconButton extends StatelessWidget {
  const _SideIconButton({
    required this.icon,
    required this.label,
    required this.bubbleColor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color bubbleColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Material(
              color: bubbleColor,
              shape: const CircleBorder(),
              child: SizedBox(
                width: 34,
                height: 34,
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: AppTheme.englishFont(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.brownDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogueLogEntry {
  const _DialogueLogEntry({required this.speaker, required this.textKey});

  final String? speaker;
  final String textKey;
}

class _DialogueLogModal extends StatelessWidget {
  const _DialogueLogModal({required this.entries, required this.i18n});

  final List<_DialogueLogEntry> entries;
  final I18nService i18n;

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      title: i18n.t('text_log.title'),
      child: entries.isEmpty
          ? const SizedBox(
              height: 140,
              child: Center(
                child: Icon(
                  Icons.history_toggle_off_rounded,
                  size: 54,
                  color: AppColors.purpleLight,
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              primary: false,
              reverse: true,
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, reverseIndex) {
                final entry = entries[entries.length - 1 - reverseIndex];
                final speaker = entry.speaker;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xB8FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.purple.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (speaker != null) ...[
                        Text(
                          _displayCharacterName(speaker),
                          style: AppTheme.englishFont(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orange,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      Text(
                        i18n.t(entry.textKey, language: 'en'),
                        style: AppTheme.japaneseFont(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brownDark,
                        ).copyWith(height: 1.35),
                      ),
                      if (i18n.language != 'en') ...[
                        const SizedBox(height: 7),
                        Text(
                          i18n.t(entry.textKey, language: i18n.language),
                          style: AppTheme.japaneseFont(
                            fontSize: 13,
                            color: AppColors.brownDark.withValues(alpha: 0.65),
                          ).copyWith(height: 1.35),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _QuickMenuModal extends StatelessWidget {
  const _QuickMenuModal({
    required this.i18n,
    required this.hasSave,
    required this.onSave,
    required this.onLoad,
    required this.onTextLog,
    required this.onVocabLog,
    required this.onSettings,
    required this.onMainMenu,
  });

  final I18nService i18n;
  final bool hasSave;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onTextLog;
  final VoidCallback onVocabLog;
  final VoidCallback onSettings;
  final VoidCallback onMainMenu;

  void _closeThen(BuildContext context, VoidCallback callback) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      title: i18n.t('quick_menu.title'),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _QuickMenuAction(
            icon: Icons.save_outlined,
            label: i18n.t('quick_menu.save'),
            color: AppColors.greenDark,
            onTap: () => _closeThen(context, onSave),
          ),
          _QuickMenuAction(
            icon: Icons.restore_rounded,
            label: i18n.t('quick_menu.load'),
            color: AppColors.purple,
            onTap: hasSave ? () => _closeThen(context, onLoad) : null,
          ),
          _QuickMenuAction(
            icon: Icons.assignment_outlined,
            label: i18n.t('quick_menu.text_log'),
            color: AppColors.purpleDark,
            onTap: () => _closeThen(context, onTextLog),
          ),
          _QuickMenuAction(
            icon: Icons.menu_book_outlined,
            label: i18n.t('quick_menu.vocab_log'),
            color: AppColors.orange,
            onTap: () => _closeThen(context, onVocabLog),
          ),
          _QuickMenuAction(
            icon: Icons.settings_outlined,
            label: i18n.t('quick_menu.settings'),
            color: AppColors.brown,
            onTap: () => _closeThen(context, onSettings),
          ),
          const SizedBox(height: 8),
          _QuickMenuAction(
            icon: Icons.home_outlined,
            label: i18n.t('quick_menu.main_menu'),
            color: AppColors.orange,
            destructive: true,
            onTap: () => _closeThen(context, onMainMenu),
          ),
        ],
      ),
    );
  }
}

class _QuickMenuAction extends StatelessWidget {
  const _QuickMenuAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: onTap == null
            ? Colors.white.withValues(alpha: 0.28)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.14),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: AppTheme.englishFont(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: onTap == null
                          ? AppColors.brownDark.withValues(alpha: 0.36)
                          : destructive
                          ? AppColors.orange
                          : AppColors.brownDark,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.brownDark.withValues(
                    alpha: onTap == null ? 0.16 : 0.42,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _displayCharacterName(String id) {
  const names = {
    'alex': 'Alex',
    'ken': 'Ken',
    'mei': 'Mei',
    'yuki': 'Yuki',
    'tanaka': 'Aoi Tanaka',
  };
  return names[id] ??
      (id.isEmpty ? id : '${id[0].toUpperCase()}${id.substring(1)}');
}

class _DialogueBox extends StatefulWidget {
  const _DialogueBox({
    super.key,
    required this.line,
    required this.i18n,
    required this.uiLanguage,
    required this.playerLevel,
    required this.translationVisible,
    required this.vocabFuture,
    required this.ttsService,
    // required this.typingSoundService,
    required this.onTap,
    required this.onTypingComplete,
    required this.onWordTap,
    required this.onToggleTranslation,
  });

  final DialogueLine line;
  final I18nService i18n;
  final String uiLanguage;
  final String playerLevel;
  final bool translationVisible;
  final Future<List<VocabWord>> vocabFuture;
  final TtsService ttsService;
  // final TypingSoundService typingSoundService;
  final VoidCallback onTap;
  final VoidCallback onTypingComplete;
  final ValueChanged<VocabWord> onWordTap;
  final VoidCallback onToggleTranslation;

  @override
  State<_DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<_DialogueBox> {
  static const _characterInterval = Duration(milliseconds: 28);

  Timer? _typingTimer;
  String _primaryText = '';
  int _visibleCharacters = 0;

  bool get _typingComplete => _visibleCharacters >= _primaryText.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextText = _resolvePrimaryText();
    if (nextText != _primaryText ||
        (_primaryText.isEmpty && _visibleCharacters == 0)) {
      _startTyping(nextText);
    }
  }

  @override
  void didUpdateWidget(covariant _DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = _resolvePrimaryText();
    if (nextText != _primaryText || widget.line != oldWidget.line) {
      _startTyping(nextText);
    }
  }

  String _resolvePrimaryText() {
    return switch (widget.line) {
      NarrationLine(text: final text) => widget.i18n.t(text, language: 'ja'),
      DialogueTextLine(text: final text) => widget.i18n.t(text, language: 'ja'),
      TitleCardLine(title: final title) => widget.i18n.t(title),
      _ => '',
    };
  }

  void _startTyping(String text) {
    _typingTimer?.cancel();
    _primaryText = text;
    _visibleCharacters = 0;
    if (text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onTypingComplete();
      });
      return;
    }
    _typingTimer = Timer.periodic(_characterInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final nextVisible = (_visibleCharacters + 1).clamp(
        0,
        _primaryText.length,
      );
      // widget.typingSoundService.playTick(
      //   speaker: speaker,
      //   character: typedCharacter,
      // );
      setState(() => _visibleCharacters = nextVisible);
      if (_typingComplete) {
        timer.cancel();
        _typingTimer = null;
        widget.onTypingComplete();
      }
    });
  }

  void _handleTap() {
    if (!_typingComplete) {
      _typingTimer?.cancel();
      _typingTimer = null;
      setState(() => _visibleCharacters = _primaryText.length);
      widget.onTypingComplete();
      return;
    }
    widget.onTap();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (speaker, text, subtitle, isSpeech) = switch (widget.line) {
      NarrationLine(text: final t) => (null, t, null, true),
      DialogueTextLine(speaker: final s, text: final t) => (s, t, null, true),
      TitleCardLine(title: final t, subtitle: final sub) => (
        null,
        t,
        sub,
        false,
      ),
      _ => (null, '', null, false),
    };

    final primaryText = _primaryText;
    final visibleText = primaryText.substring(0, _visibleCharacters);
    final hasStoryTranslations =
        widget.line is NarrationLine || widget.line is DialogueTextLine;
    final resolvedRomaji = hasStoryTranslations
        ? widget.i18n.t(text, language: 'romaji')
        : null;
    final romajiText =
        resolvedRomaji != null &&
            resolvedRomaji.isNotEmpty &&
            resolvedRomaji.trim() != primaryText.trim()
        ? resolvedRomaji
        : null;
    final resolvedTranslation = hasStoryTranslations
        ? widget.i18n.t(text, language: widget.uiLanguage)
        : null;
    final translatedText =
        resolvedTranslation != null &&
            resolvedTranslation.trim() != primaryText.trim()
        ? resolvedTranslation
        : null;
    final ttsText = translatedText ?? primaryText;

    final hasSpeaker = speaker != null && speaker != 'player';
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 720;
    final baseFontSize = isWide && size.height > 500 ? 26.0 : 20.0;

    return GestureDetector(
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GlassPanel(
              borderRadius: AppRadii.dialogueBox,
              blurSigma: AppBlur.dialogueBox,
              shadows: AppShadows.dialogueBox,
              padding: EdgeInsets.fromLTRB(24, hasSpeaker ? 20 : 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSpeech)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => widget.ttsService.speak(ttsText),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.grey.shade700,
                              size: 18,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: widget.onToggleTranslation,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.translate,
                              size: 18,
                              color: widget.translationVisible
                                  ? AppColors.orange
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isSpeech)
                    Stack(
                      children: [
                        // ExcludeSemantics(
                        //   child: IgnorePointer(
                        //     child: Opacity(
                        //       opacity: 0,
                        //       child: _VocabAwareText(
                        //         text: englishText,
                        //         vocabFuture: widget.vocabFuture,
                        //         i18n: widget.i18n,
                        //         ttsService: widget.ttsService,
                        //         playerLevel: widget.playerLevel,
                        //         onWordTap: widget.onWordTap,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        _VocabAwareText(
                          text: visibleText,
                          vocabFuture: widget.vocabFuture,
                          i18n: widget.i18n,
                          ttsService: widget.ttsService,
                          playerLevel: widget.playerLevel,
                          onWordTap: widget.onWordTap,
                          baseFontSize: baseFontSize,
                        ),
                      ],
                    )
                  else
                    Text(
                      primaryText,
                      style: AppTheme.japaneseFont(
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.brownDark,
                      ).copyWith(height: 1.7),
                    ),
                  if (isSpeech && romajiText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        romajiText,
                        style: AppTheme.englishFont(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.purpleDark.withValues(alpha: 0.72),
                        ).copyWith(height: 1.35),
                      ),
                    ),
                  if (isSpeech &&
                      widget.translationVisible &&
                      translatedText != null &&
                      translatedText.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0x266F52B5)),
                        ), // rgba(111,82,181,0.15)
                      ),
                      child: Text(
                        translatedText,
                        style: AppTheme.japaneseFont(
                          fontSize: 18,
                          color: AppColors.brownDark.withValues(alpha: 0.75),
                        ).copyWith(fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ),
                  if (!isSpeech && subtitle != null && subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        widget.i18n.t(subtitle),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (hasSpeaker)
              Positioned(
                top: -14,
                left: 22,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD9C0), Color(0xFFE3D9F7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40906FD1),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    _displayName(speaker),
                    style: AppTheme.englishFont(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.purpleDark,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _displayName(String id) {
    const names = {
      'alex': 'Alex',
      'ken': 'Ken',
      'mei': 'Mei',
      'yuki': 'Yuki',
      'tanaka': 'Aoi Tanaka',
    };
    return names[id] ?? id;
  }
}

class _VocabAwareText extends StatelessWidget {
  const _VocabAwareText({
    required this.text,
    required this.vocabFuture,
    required this.i18n,
    required this.ttsService,
    required this.playerLevel,
    required this.onWordTap,
    this.baseFontSize = 26,
  });

  final String text;
  final Future<List<VocabWord>> vocabFuture;
  final I18nService i18n;
  final TtsService ttsService;
  final String playerLevel;
  final ValueChanged<VocabWord> onWordTap;
  final double baseFontSize;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VocabWord>>(
      future: vocabFuture,
      builder: (context, snapshot) {
        final baseStyle = AppTheme.japaneseFont(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w500,
          color: AppColors.brownDark,
        ).copyWith(height: 1.7);

        final vocabulary = snapshot.data;
        if (vocabulary == null) {
          return Text(text, style: baseStyle);
        }

        final matches = findVocabularyInText(
          text,
          vocabulary,
          playerLevel: playerLevel,
        );
        if (matches.isEmpty) {
          return Text(text, style: baseStyle);
        }

        final spans = <InlineSpan>[];
        var pos = 0;
        for (final match in matches) {
          if (match.start > pos) {
            spans.add(TextSpan(text: text.substring(pos, match.start)));
          }
          final isTarget = match.word.level == playerLevel;
          spans.add(
            TextSpan(
              text: text.substring(match.start, match.end),
              style: TextStyle(
                backgroundColor: isTarget
                    ? const Color(0x59FFD89B) // rgba(255,216,155,0.35)
                    : const Color(0x3894B49F), // rgba(148,180,159,0.22)
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationColor: isTarget ? AppColors.orange : AppColors.purple,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onWordTap(match.word);
                  final box = context.findRenderObject() as RenderBox?;
                  final anchor = box == null
                      ? const Offset(0, 0)
                      : box.localToGlobal(box.size.center(Offset.zero));
                  showVocabPopup(
                    context,
                    anchor: anchor,
                    word: match.word,
                    i18n: i18n,
                    ttsService: ttsService,
                    uiLanguage: i18n.language,
                  );
                },
            ),
          );
          pos = match.end;
        }
        if (pos < text.length) spans.add(TextSpan(text: text.substring(pos)));

        return Text.rich(TextSpan(style: baseStyle, children: spans));
      },
    );
  }
}

class _ChoicePanel extends StatelessWidget {
  const _ChoicePanel({
    required this.choices,
    required this.i18n,
    required this.japaneseFirst,
    required this.showTranslation,
    required this.uiLanguage,
    required this.onSelect,
  });

  final List<DialogueChoice> choices;
  final I18nService i18n;
  final bool japaneseFirst;
  final bool showTranslation;
  final String uiLanguage;
  final ValueChanged<DialogueChoice> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        final useColumns = constraints.maxWidth >= 720 && choices.length > 2;
        final panelMaxWidth = constraints.maxWidth >= 1100 ? 1040.0 : 820.0;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        final panelMaxHeight = availableHeight * (compact ? 0.72 : 0.64);

        // The portrait side menu remains available during choices. Reserve
        // its lane so it never covers the response text or tap targets.
        final outerPadding = compact
            ? const EdgeInsets.fromLTRB(12, 12, 12, 12)
            : const EdgeInsets.fromLTRB(24, 16, 96, 20);
        final panelPadding = compact ? 10.0 : 16.0;

        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: outerPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: panelMaxWidth,
                maxHeight: panelMaxHeight,
              ),
              child: GlassPanel(
                borderRadius: compact ? 24 : AppRadii.dialogueBox,
                blurSigma: AppBlur.dialogueBox,
                shadows: AppShadows.dialogueBox,
                padding: EdgeInsets.all(panelPadding),
                child: SingleChildScrollView(
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  child: LayoutBuilder(
                    builder: (context, innerConstraints) {
                      const spacing = 10.0;
                      final itemWidth = useColumns
                          ? (innerConstraints.maxWidth - spacing) / 2
                          : innerConstraints.maxWidth;

                      return Column(
                        spacing: spacing,
                        children: [
                          for (var index = 0; index < choices.length; index++)
                            _buildChoice(
                              index: index,
                              width: itemWidth,
                              compact: compact,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChoice({
    required int index,
    required double width,
    required bool compact,
  }) {
    final choice = choices[index];
    final primaryText = i18n.t(
      choice.text,
      language: japaneseFirst ? 'ja' : 'en',
    );
    final resolvedRomaji = japaneseFirst
        ? i18n.t(choice.text, language: 'romaji')
        : null;
    final romajiText =
        resolvedRomaji != null && resolvedRomaji.trim() != primaryText.trim()
        ? resolvedRomaji
        : null;
    final resolvedTranslation = showTranslation
        ? i18n.t(choice.text, language: uiLanguage)
        : null;
    final translatedText =
        resolvedTranslation != null &&
            resolvedTranslation.trim() != primaryText.trim() &&
            resolvedTranslation.trim() != romajiText?.trim()
        ? resolvedTranslation
        : null;

    return SizedBox(
      width: width,
      child: _AdaptiveChoiceButton(
        number: index + 1,
        primaryText: primaryText,
        romanizedText: romajiText,
        translatedText: translatedText,
        japaneseFirst: japaneseFirst,
        compact: compact,
        onTap: () => onSelect(choice),
      ),
    );
  }
}

class _AdaptiveChoiceButton extends StatelessWidget {
  const _AdaptiveChoiceButton({
    required this.number,
    required this.primaryText,
    required this.romanizedText,
    required this.translatedText,
    required this.japaneseFirst,
    required this.compact,
    required this.onTap,
  });

  final int number;
  final String primaryText;
  final String? romanizedText;
  final String? translatedText;
  final bool japaneseFirst;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(compact ? 16 : 20);

    return Semantics(
      button: true,
      label: primaryText,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.orange.withValues(alpha: 0.16),
          highlightColor: AppColors.purple.withValues(alpha: 0.06),
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: compact ? 12 : 15,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xF7FFFFFF), Color(0xEDF9F3FF)],
              ),
              borderRadius: radius,
              border: Border.all(
                color: AppColors.purple.withValues(alpha: 0.16),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x15906FD1),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: compact ? 32 : 38,
                  height: compact ? 32 : 38,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD8C2), Color(0xFFE5D7FA)],
                    ),
                  ),
                  child: Text(
                    '$number',
                    style: AppTheme.englishFont(
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.purpleDark,
                    ),
                  ),
                ),
                SizedBox(width: compact ? 10 : 13),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryText,
                        style:
                            (japaneseFirst
                                    ? AppTheme.japaneseFont(
                                        fontSize: compact ? 15 : 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.brownDark,
                                      )
                                    : AppTheme.englishFont(
                                        fontSize: compact ? 15 : 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.brownDark,
                                      ))
                                .copyWith(height: 1.25),
                      ),
                      if (romanizedText != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          romanizedText!,
                          style: AppTheme.englishFont(
                            fontSize: compact ? 11.5 : 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.purpleDark.withValues(alpha: 0.72),
                          ).copyWith(height: 1.2),
                        ),
                      ],
                      if (translatedText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          translatedText!,
                          style: AppTheme.englishFont(
                            fontSize: compact ? 11.5 : 12.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.purpleDark.withValues(alpha: 0.68),
                          ).copyWith(height: 1.25),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: compact ? 6 : 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: compact ? 18 : 20,
                  color: AppColors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
