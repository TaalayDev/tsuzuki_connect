import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dialogue_line.dart';
import '../models/story.dart';
import '../services/content_service.dart';

/// Position + expression of one on-screen character, keyed by dialogue
/// character id (e.g. 'alex', 'mei') in [ScenePlayerState.characters].
class CharacterView {
  const CharacterView({required this.position, required this.expression});

  final String position;
  final String expression;

  CharacterView copyWith({String? position, String? expression}) {
    return CharacterView(
      position: position ?? this.position,
      expression: expression ?? this.expression,
    );
  }
}

/// What the player is currently waiting on. Mirrors the tap-to-advance /
/// choice-menu / scene-finished states `SceneManager.js` drove through DOM
/// visibility toggles.
enum PlayerStatus { loading, line, choice, finished }

class ScenePlayerState {
  const ScenePlayerState({
    this.status = PlayerStatus.loading,
    this.story,
    this.currentScene,
    this.lineIndex = 0,
    this.characters = const {},
    this.background,
    this.backgroundTime,
    this.currentMusic,
    this.flags = const {},
  });

  final PlayerStatus status;
  final Story? story;
  final DialogueScene? currentScene;
  final int lineIndex;
  final Map<String, CharacterView> characters;
  final String? background;
  final String? backgroundTime;
  final String? currentMusic;
  final Map<String, dynamic> flags;

  /// The line the player is currently blocked on (a dialogue/narration
  /// line to show, or a choice line) — null while loading or finished.
  DialogueLine? get currentLine {
    final scene = currentScene;
    if (scene == null || lineIndex >= scene.lines.length) return null;
    return scene.lines[lineIndex];
  }

  ScenePlayerState copyWith({
    PlayerStatus? status,
    Story? story,
    DialogueScene? currentScene,
    int? lineIndex,
    Map<String, CharacterView>? characters,
    String? background,
    String? backgroundTime,
    String? currentMusic,
    Map<String, dynamic>? flags,
  }) {
    return ScenePlayerState(
      status: status ?? this.status,
      story: story ?? this.story,
      currentScene: currentScene ?? this.currentScene,
      lineIndex: lineIndex ?? this.lineIndex,
      characters: characters ?? this.characters,
      background: background ?? this.background,
      backgroundTime: backgroundTime ?? this.backgroundTime,
      currentMusic: currentMusic ?? this.currentMusic,
      flags: flags ?? this.flags,
    );
  }
}

/// Walks a [Story]'s scenes/lines, mirroring `js/engine/SceneManager.js`:
/// side-effect lines (background/character/music/flag/jump/...) are applied
/// silently and immediately; "blocking" lines (dialogue, narration, choice)
/// stop the walk until the player taps to continue or picks a choice.
class ScenePlayerNotifier extends Notifier<ScenePlayerState> {
  late ContentService _contentService;
  Map<String, DialogueScene> _sceneIndex = {};

  @override
  ScenePlayerState build() {
    _contentService = ref.read(contentServiceProvider);
    return const ScenePlayerState();
  }

  Future<void> loadStory(ContentCategory category, String id) async {
    state = const ScenePlayerState(status: PlayerStatus.loading);
    final story = await _contentService.loadStory(category, id);
    _indexScenes(story);
    final first = story.scenes.first;
    state = ScenePlayerState(story: story, currentScene: first, lineIndex: 0);
    _runUntilBlocking();
  }

  /// Restores a quick-save snapshot after reloading its story content.
  /// Returns false when the snapshot is malformed or points to a scene that
  /// no longer exists, allowing callers to leave the current game untouched.
  Future<bool> restoreStory(
    ContentCategory category,
    String id,
    Map<String, dynamic> snapshot,
  ) async {
    try {
      state = const ScenePlayerState(status: PlayerStatus.loading);
      final story = await _contentService.loadStory(category, id);
      _indexScenes(story);
      final sceneKey = snapshot['sceneId'] as String?;
      final scene = sceneKey == null ? null : _sceneIndex[sceneKey];
      if (scene == null) {
        await loadStory(category, id);
        return false;
      }

      final charactersJson = snapshot['characters'] as Map? ?? const {};
      final characters = <String, CharacterView>{
        for (final entry in charactersJson.entries)
          if (entry.value is Map)
            entry.key.toString(): CharacterView(
              position: (entry.value as Map)['position'] as String? ?? 'center',
              expression:
                  (entry.value as Map)['expression'] as String? ?? 'neutral',
            ),
      };
      final lineIndex = (snapshot['lineIndex'] as num?)?.toInt() ?? 0;
      final flags = Map<String, dynamic>.from(
        snapshot['flags'] as Map? ?? const {},
      );

      state = ScenePlayerState(
        story: story,
        currentScene: scene,
        lineIndex: lineIndex.clamp(0, scene.lines.length),
        characters: characters,
        background: snapshot['background'] as String?,
        backgroundTime: snapshot['backgroundTime'] as String?,
        currentMusic: snapshot['currentMusic'] as String?,
        flags: flags,
      );

      final line = state.currentLine;
      if (line == null) {
        _runUntilBlocking();
      } else {
        state = state.copyWith(
          status: line is ChoiceLine ? PlayerStatus.choice : PlayerStatus.line,
        );
      }
      return true;
    } catch (_) {
      await loadStory(category, id);
      return false;
    }
  }

  Map<String, dynamic>? createSnapshot() {
    final scene = state.currentScene;
    if (state.story == null || scene == null) return null;
    return {
      'sceneId': scene.id,
      'lineIndex': state.lineIndex,
      'characters': {
        for (final entry in state.characters.entries)
          entry.key: {
            'position': entry.value.position,
            'expression': entry.value.expression,
          },
      },
      'background': state.background,
      'backgroundTime': state.backgroundTime,
      'currentMusic': state.currentMusic,
      'flags': state.flags,
    };
  }

  /// Advances past the current dialogue/narration line. No-op if the
  /// player is currently on a choice (call [selectChoice] instead) or the
  /// scene has finished.
  void advance() {
    if (state.status != PlayerStatus.line) return;
    state = state.copyWith(lineIndex: state.lineIndex + 1);
    _runUntilBlocking();
  }

  void selectChoice(DialogueChoice choice) {
    if (state.status != PlayerStatus.choice) return;
    _jumpTo(choice.next);
    _runUntilBlocking();
  }

  void _jumpTo(String label) {
    final target = _sceneIndex[label];
    if (target == null) {
      // Unknown label — treat as end of story rather than crash; a content
      // bug should surface as "story ended early" in QA, not a hard crash.
      state = state.copyWith(status: PlayerStatus.finished, currentScene: null);
      return;
    }
    state = state.copyWith(currentScene: target, lineIndex: 0);
  }

  void _indexScenes(Story story) {
    _sceneIndex = {
      for (final scene in story.scenes) scene.id: scene,
      for (final scene in story.scenes) scene.label: scene,
    };
  }

  void _runUntilBlocking() {
    while (true) {
      final scene = state.currentScene;
      if (scene == null) {
        state = state.copyWith(status: PlayerStatus.finished);
        return;
      }
      if (state.lineIndex >= scene.lines.length) {
        // Scene ran off the end without an explicit end()/jump() — nothing
        // left to do.
        state = state.copyWith(status: PlayerStatus.finished);
        return;
      }

      final line = scene.lines[state.lineIndex];
      switch (line) {
        case BackgroundLine(bg: final bg, time: final time):
          state = state.copyWith(
            background: bg,
            backgroundTime: time,
            lineIndex: state.lineIndex + 1,
          );
        case CharacterLine(
          name: final name,
          position: final position,
          expression: final expression,
        ):
          state = state.copyWith(
            characters: {
              ...state.characters,
              name: CharacterView(position: position, expression: expression),
            },
            lineIndex: state.lineIndex + 1,
          );
        case CharacterHideLine(name: final name):
          final next = {...state.characters}..remove(name);
          state = state.copyWith(
            characters: next,
            lineIndex: state.lineIndex + 1,
          );
        case CharacterHideAllLine():
          state = state.copyWith(
            characters: const {},
            lineIndex: state.lineIndex + 1,
          );
        case CharacterMoveLine(name: final name, position: final position):
          final existing = state.characters[name];
          if (existing != null) {
            state = state.copyWith(
              characters: {
                ...state.characters,
                name: existing.copyWith(position: position),
              },
            );
          }
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case CharacterExpressLine(
          name: final name,
          expression: final expression,
        ):
          final existing = state.characters[name];
          if (existing != null) {
            state = state.copyWith(
              characters: {
                ...state.characters,
                name: existing.copyWith(expression: expression),
              },
            );
          }
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case MusicLine(track: final track):
          state = state.copyWith(
            currentMusic: track,
            lineIndex: state.lineIndex + 1,
          );
        case SfxLine():
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case EffectLine():
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case RelationshipLine():
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case FlagLine(flag: final flag, value: final value):
          state = state.copyWith(flags: {...state.flags, flag: value});
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case ConditionLine(
          flag: final flag,
          ifTrue: final ifTrue,
          ifFalse: final ifFalse,
        ):
          final isTrue = state.flags[flag] == true;
          final target = isTrue ? ifTrue : ifFalse;
          if (target != null) {
            _jumpTo(target);
            continue;
          }
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case WaitLine():
          state = state.copyWith(lineIndex: state.lineIndex + 1);
        case JumpLine(target: final target):
          _jumpTo(target);
        case EndLine():
          state = state.copyWith(status: PlayerStatus.finished);
          return;
        case NarrationLine():
        case DialogueTextLine():
        case TitleCardLine():
          state = state.copyWith(status: PlayerStatus.line);
          return;
        case ChoiceLine():
          state = state.copyWith(status: PlayerStatus.choice);
          return;
      }
    }
  }
}

final contentServiceProvider = Provider<ContentService>(
  (ref) => ContentService(),
);

final scenePlayerProvider =
    NotifierProvider<ScenePlayerNotifier, ScenePlayerState>(
      ScenePlayerNotifier.new,
    );
