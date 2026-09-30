import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/save_service.dart';
import 'settings_provider.dart';

/// Mirrors `restoreProgressFlags()` / `completedStories` / `completedLessons`
/// / `completedVocabLessons` / `vocabLearned` in `js/main.js`. Kept separate
/// from live scene state so opening a menu tab (Story/Sentences/Vocabulary)
/// can check "is this unlocked / already done" without resuming gameplay —
/// this separation is what the original JS version was missing, causing the
/// "menu buttons always resume the same saved lesson" bug fixed mid-project.
class ProgressState {
  const ProgressState({
    this.completedStories = const <String>{},
    this.completedLessons = const <String>{},
    this.completedVocabLessons = const <String>{},
    this.vocabLearned = const <String>{},
    this.isPremium = false,
    this.lessonModeStarted = false,
    this.vocabModeStarted = false,
    this.pendingOnboardingTrack,
  });

  final Set<String> completedStories;
  final Set<String> completedLessons;
  final Set<String> completedVocabLessons;
  final Set<String> vocabLearned;
  final bool isPremium;

  /// `Game.state.lessonModeStarted`/`vocabModeStarted` — whether the player
  /// has ever entered Sentences/Vocabulary mode at least once. The main
  /// menu jumps straight into the first lesson matching their chosen level
  /// the very first time (see `AccessPolicy.firstLessonIdForLevel`), then
  /// opens the normal topic list on every visit after that.
  final bool lessonModeStarted;
  final bool vocabModeStarted;

  /// `Game.state.pendingOnboardingTrack` — set right before the shared
  /// `story0` onboarding chapter is (re-)entered from the Sentences/
  /// Vocabulary menu buttons (not Story), one of `'lesson'`/
  /// `'vocab-lesson'`, so that once `story0` ends, the completion routing
  /// knows to continue into that track's first lesson instead of falling
  /// through to `story1`. Cleared as soon as it's consumed.
  final String? pendingOnboardingTrack;

  ProgressState copyWith({
    Set<String>? completedStories,
    Set<String>? completedLessons,
    Set<String>? completedVocabLessons,
    Set<String>? vocabLearned,
    bool? isPremium,
    bool? lessonModeStarted,
    bool? vocabModeStarted,
    String? pendingOnboardingTrack,
    bool clearPendingOnboardingTrack = false,
  }) {
    return ProgressState(
      completedStories: completedStories ?? this.completedStories,
      completedLessons: completedLessons ?? this.completedLessons,
      completedVocabLessons:
          completedVocabLessons ?? this.completedVocabLessons,
      vocabLearned: vocabLearned ?? this.vocabLearned,
      isPremium: isPremium ?? this.isPremium,
      lessonModeStarted: lessonModeStarted ?? this.lessonModeStarted,
      vocabModeStarted: vocabModeStarted ?? this.vocabModeStarted,
      pendingOnboardingTrack: clearPendingOnboardingTrack
          ? null
          : (pendingOnboardingTrack ?? this.pendingOnboardingTrack),
    );
  }

  Map<String, dynamic> toJson() => {
    'completedStories': completedStories.toList(),
    'completedLessons': completedLessons.toList(),
    'completedVocabLessons': completedVocabLessons.toList(),
    'vocabLearned': vocabLearned.toList(),
    'isPremium': isPremium,
    'lessonModeStarted': lessonModeStarted,
    'vocabModeStarted': vocabModeStarted,
    'pendingOnboardingTrack': pendingOnboardingTrack,
  };

  factory ProgressState.fromJson(Map<String, dynamic> json) => ProgressState(
    completedStories: ((json['completedStories'] as List?) ?? [])
        .cast<String>()
        .toSet(),
    completedLessons: ((json['completedLessons'] as List?) ?? [])
        .cast<String>()
        .toSet(),
    completedVocabLessons: ((json['completedVocabLessons'] as List?) ?? [])
        .cast<String>()
        .toSet(),
    vocabLearned: ((json['vocabLearned'] as List?) ?? [])
        .cast<String>()
        .toSet(),
    isPremium: json['isPremium'] as bool? ?? false,
    lessonModeStarted: json['lessonModeStarted'] as bool? ?? false,
    vocabModeStarted: json['vocabModeStarted'] as bool? ?? false,
    pendingOnboardingTrack: json['pendingOnboardingTrack'] as String?,
  );
}

class ProgressNotifier extends Notifier<ProgressState> {
  late SaveService _saveService;

  @override
  ProgressState build() {
    _saveService = ref.read(saveServiceProvider);
    final stored = _saveService.progress;
    return stored.isEmpty
        ? const ProgressState()
        : ProgressState.fromJson(stored);
  }

  void markStoryComplete(String storyId) {
    state = state.copyWith(
      completedStories: {...state.completedStories, storyId},
    );
    _persist();
  }

  void markLessonComplete(String lessonId) {
    state = state.copyWith(
      completedLessons: {...state.completedLessons, lessonId},
    );
    _persist();
  }

  void markVocabLessonComplete(String lessonId) {
    state = state.copyWith(
      completedVocabLessons: {...state.completedVocabLessons, lessonId},
    );
    _persist();
  }

  void markWordLearned(String wordId) {
    if (wordId.isEmpty || state.vocabLearned.contains(wordId)) return;
    state = state.copyWith(vocabLearned: {...state.vocabLearned, wordId});
    _persist();
  }

  void markWordsLearned(Iterable<String> wordIds) {
    final validIds = wordIds.where((id) => id.isNotEmpty).toSet();
    final next = {...state.vocabLearned, ...validIds};
    if (next.length == state.vocabLearned.length) return;
    state = state.copyWith(vocabLearned: next);
    _persist();
  }

  void setPremium(bool owned) {
    state = state.copyWith(isPremium: owned);
    _persist();
  }

  void markLessonModeStarted() {
    state = state.copyWith(lessonModeStarted: true);
    _persist();
  }

  void markVocabModeStarted() {
    state = state.copyWith(vocabModeStarted: true);
    _persist();
  }

  void setPendingOnboardingTrack(String? track) {
    state = track == null
        ? state.copyWith(clearPendingOnboardingTrack: true)
        : state.copyWith(pendingOnboardingTrack: track);
    _persist();
  }

  /// Consumes and clears the pending onboarding track in one step —
  /// `SceneManager.endStory()` reads `pendingOnboardingTrack` once when
  /// `story0` completes, then immediately clears it.
  String? consumePendingOnboardingTrack() {
    final track = state.pendingOnboardingTrack;
    if (track != null) {
      state = state.copyWith(clearPendingOnboardingTrack: true);
      _persist();
    }
    return track;
  }

  void _persist() => _saveService.saveProgress(state.toJson());
}

final progressProvider = NotifierProvider<ProgressNotifier, ProgressState>(
  ProgressNotifier.new,
);
