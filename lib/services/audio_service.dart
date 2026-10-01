import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Plays the logical music cues used by story JSON with the tracks bundled
/// under `assets/audio/`, porting `js/engine/AudioManager.js`'s real
/// (non-dead-code) BGM path — the actual shipped app plays plain looping
/// `<audio>` files, not the Tone.js synth engine `AudioManager.js` also
/// contains; every `playXMusic()` method in that file was overridden to
/// just call its `_playAssetBgm()`, so that's the only path worth porting.
///
/// Story content inherited several cue names from the web version while this
/// Flutter project ships a smaller soundtrack. Keeping the mapping here makes
/// every cue audible without leaking asset-file details into scene playback.
class AudioService with WidgetsBindingObserver {
  AudioService({AudioPlayer? musicPlayer})
    : _musicPlayer = musicPlayer ?? AudioPlayer(playerId: 'scene_music') {
    WidgetsBinding.instance.addObserver(this);
    // Play the BGM without entering the Android audio-focus fight. The scene
    // background video (muted) and the synthesized typing ticks would each
    // otherwise cause the OS to pause/duck this player when they start. Mixing
    // keeps looping music steady regardless of what else the app is playing.
    unawaited(
      AudioPlayer.global.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      ),
    );
    unawaited(_musicPlayer.setReleaseMode(ReleaseMode.loop));
    _recoveryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Only nudge playback when the native player is not already playing.
      // A frozen position while `state == playing` is common on Android (the
      // position stream simply stops emitting) and force-restarting on that
      // signal caused a stop/play loop that eventually wedged the player.
      unawaited(ensureMusicPlaying());
    });
    _positionSubscription = _musicPlayer.onPositionChanged.listen((position) {
      if (position != _lastPosition) {
        _lastPosition = position;
        _lastPositionChange = DateTime.now();
      }
    });
  }

  final AudioPlayer _musicPlayer;

  double _masterVolume = 0.8;
  double _musicVolume = 0.7;
  // `AudioManager.toggleMute()`/`isMuted()` — a standalone on/off layered
  // on top of the volume sliders (the main menu's "Sound: On/Off" button),
  // not persisted to settings — same as the JS version, which keeps it as
  // in-memory state that resets every session.
  bool _muted = false;
  String? _currentTrack;
  Object? _currentOwner;
  Timer? _fadeTimer;
  late final Timer _recoveryTimer;
  bool _appActive = true;
  Future<void> _commandQueue = Future.value();
  int _pendingOperations = 0;
  int _intentGeneration = 0;
  Duration? _lastPosition;
  DateTime _lastPositionChange = DateTime.now();
  late final StreamSubscription<Duration> _positionSubscription;

  static const Map<String, String> _musicAssets = {
    'menu': 'audio/spaceship earth_mp3.mp3',
    'acoustic_nostalgia': 'audio/flight home_mp3.mp3',
    'cafe': 'audio/rain on mars_mp3.mp3',
    'calm': 'audio/mpk plaza_mp3.mp3',
    'classroom': 'audio/mpk plaza_mp3.mp3',
    'emotional': 'audio/flight home_mp3.mp3',
    'focused': 'audio/mpk plaza_mp3.mp3',
    'formal': 'audio/spaceship earth_mp3.mp3',
    'jazz_mellow': 'audio/mpk plaza_mp3.mp3',
    'neutral': 'audio/lunar lounging_mp3.mp3',
    'never_too_late': 'audio/sol beach (day) mp3.mp3',
    'return_bittersweet': 'audio/rain on mars_mp3.mp3',
    'warm_reunion': 'audio/flight home_mp3.mp3',
    'written_words': 'audio/lunar lounging_mp3.mp3',
    'night': 'audio/spaceship earth_mp3.mp3',
    'tense': 'audio/paradise wasteland_mp3.mp3',
    'upbeat': 'audio/sol beach (day) mp3.mp3',
    'chill': 'audio/spaceship earth_mp3.mp3',
    'hopeful': 'audio/sol beach (day) mp3.mp3',
    'warm': 'audio/flight home_mp3.mp3',
    'warm_ensemble': 'audio/flight home_mp3.mp3',
    'calm_domestic': 'audio/mpk plaza_mp3.mp3',
    'cafe_gentle': 'audio/rain on mars_mp3.mp3',
    'classical_piano_gentle': 'audio/lunar lounging_mp3.mp3',
    'gentle_close': 'audio/flight home_mp3.mp3',
    'gentle_strings': 'audio/flight home_mp3.mp3',
    'never_too_late_reprise': 'audio/sol beach (day) mp3.mp3',
    'nostalgic': 'audio/flight home_mp3.mp3',
    'quiet_contemplative': 'audio/lunar lounging_mp3.mp3',
    'quiet_discovery': 'audio/lunar lounging_mp3.mp3',
    'quiet_domestic': 'audio/mpk plaza_mp3.mp3',
    'quiet_melancholy': 'audio/rain on mars_mp3.mp3',
    'quiet_study': 'audio/mpk plaza_mp3.mp3',
    'return_full_reprise': 'audio/rain on mars_mp3.mp3',
    'return_gentle': 'audio/rain on mars_mp3.mp3',
    'sad': 'audio/rain on mars_mp3.mp3',
    'urban_night': 'audio/spaceship earth_mp3.mp3',
    'written_words_full': 'audio/lunar lounging_mp3.mp3',
    'written_words_reprise': 'audio/lunar lounging_mp3.mp3',
  };

  static String? assetForMusic(String? track) {
    if (track == null || track.trim().isEmpty) return null;
    return _musicAssets[track.trim().toLowerCase()];
  }

  bool get isMuted => _muted;

  /// `AudioManager.playMenuMusic()` — dedicated entry point for the main
  /// menu's background track (`bgmManifest.menu`, "spaceship earth"), so
  /// callers don't need to know its literal cue name.
  Future<void> playMenuMusic({Object? owner, double fadeInSeconds = 0}) {
    return playMusic('menu', owner: owner, fadeInSeconds: fadeInSeconds);
  }

  /// Starts [track] looping. Unlike the JS version's dead Tone.js bus
  /// graph, volume here is just `master * music` applied directly to the
  /// single `<audio>`-equivalent player — see `_effectiveMusicVolume`.
  Future<void> playMusic(
    String? track, {
    Object? owner,
    double fadeInSeconds = 0,
  }) async {
    final asset = assetForMusic(track);
    if (asset == null) {
      await stopMusic(owner: owner);
      return;
    }

    final normalizedTrack = track!.trim().toLowerCase();
    _cancelFade();
    _currentOwner = owner;
    if (_currentTrack == normalizedTrack) {
      await ensureMusicPlaying();
      return;
    }

    _currentTrack = normalizedTrack;
    final generation = ++_intentGeneration;
    await _enqueue(() async {
      if (generation != _intentGeneration) return;
      try {
        await _musicPlayer.stop();
        if (generation != _intentGeneration) return;
        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        _markPlaybackStarted();
        if (fadeInSeconds > 0) {
          await _musicPlayer.setVolume(0);
          await _musicPlayer.play(AssetSource(asset));
          if (generation == _intentGeneration) {
            _rampVolume(from: 0, duration: _secondsToDuration(fadeInSeconds));
          }
        } else {
          await _musicPlayer.play(
            AssetSource(asset),
            volume: _effectiveMusicVolume,
          );
        }
      } catch (_) {
        // Keep requested music as desired state. Recovery retries when the
        // Android/iOS audio backend becomes available again.
      }
    });
  }

  /// Restarts the desired track if the native player was interrupted.
  ///
  /// This is intentionally idempotent and is also safe to call from a user
  /// gesture or `reassemble()` after hot reload.
  Future<void> ensureMusicPlaying({bool forceRestart = false}) async {
    final track = _currentTrack;
    if (!_appActive || track == null || _pendingOperations > 0) return;

    if (_musicPlayer.state == PlayerState.playing && !forceRestart) {
      await _musicPlayer.setVolume(_effectiveMusicVolume);
      return;
    }

    final asset = assetForMusic(track);
    if (asset == null) return;
    final generation = _intentGeneration;
    await _enqueue(() async {
      if (generation != _intentGeneration || _currentTrack != track) return;
      try {
        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        if (_musicPlayer.state == PlayerState.paused && !forceRestart) {
          await _musicPlayer.setVolume(_effectiveMusicVolume);
          await _musicPlayer.resume();
        } else {
          if (forceRestart) await _musicPlayer.stop();
          if (generation != _intentGeneration) return;
          await _musicPlayer.play(
            AssetSource(asset),
            volume: _effectiveMusicVolume,
          );
        }
        _markPlaybackStarted();
      } catch (_) {
        // Keep desired state so a later lifecycle/watchdog pass can retry.
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = state == AppLifecycleState.resumed;
    if (_appActive) unawaited(ensureMusicPlaying());
  }

  /// `AudioManager.fadeOutMusic()` — a linear fade of whatever's currently
  /// playing down to silence (1500ms in 50ms steps in the JS version),
  /// then a hard stop. This is never a true crossfade in the original —
  /// the next track (if any) only starts once this finishes.
  Future<void> fadeOutMusic({
    Object? owner,
    Duration duration = const Duration(milliseconds: 1500),
  }) async {
    if (_ownedByOther(owner)) return;
    _cancelFade();

    final startVolume = _effectiveMusicVolume;
    if (startVolume <= 0 || _currentTrack == null) {
      await stopMusic(owner: owner);
      return;
    }

    final completer = Completer<void>();
    const stepMs = 50;
    final steps = (duration.inMilliseconds / stepMs).floor().clamp(1, 1000000);
    var step = 0;
    _fadeTimer = Timer.periodic(const Duration(milliseconds: stepMs), (timer) {
      step++;
      final t = (step / steps).clamp(0.0, 1.0);
      unawaited(_musicPlayer.setVolume(startVolume * (1 - t)));
      if (t >= 1.0) {
        timer.cancel();
        if (identical(_fadeTimer, timer)) _fadeTimer = null;
        unawaited(
          stopMusic(owner: owner).then((_) {
            if (!completer.isCompleted) completer.complete();
          }),
        );
      }
    });
    return completer.future;
  }

  /// `AudioManager.fadeToGameMusic(storyId)` — fade out whatever's playing
  /// (menu music, or a previous chapter's track), then hard-switch into
  /// [track]. Only used at chapter/lesson *start* — mid-story `{type:
  /// 'music'}` lines call [playMusic] directly instead, an instant cut
  /// with no fade, matching `SceneManager`'s `playGameMusic()` call sites.
  Future<void> fadeToGameMusic(String? track, {Object? owner}) async {
    if (_ownedByOther(owner)) return;
    await playMusic(track, owner: owner, fadeInSeconds: 0.35);
  }

  /// `AudioManager.fadeToMenuMusic()` — the reverse, used when returning
  /// to the main menu from gameplay.
  Future<void> fadeToMenuMusic({Object? owner}) async {
    if (_ownedByOther(owner)) return;
    await playMenuMusic(fadeInSeconds: 0.5);
  }

  void setVolumes({required double master, required double music}) {
    _masterVolume = master.clamp(0.0, 1.0);
    _musicVolume = music.clamp(0.0, 1.0);
    if (_fadeTimer == null) {
      unawaited(_musicPlayer.setVolume(_effectiveMusicVolume));
    }
  }

  /// `AudioManager.toggleMute()`/`isMuted()` — independent of the volume
  /// sliders; wired to the main menu's standalone "Sound: On/Off" toggle.
  void setMuted(bool muted) {
    _muted = muted;
    if (_fadeTimer == null) {
      unawaited(_musicPlayer.setVolume(_effectiveMusicVolume));
    }
  }

  double get _effectiveMusicVolume => _muted ? 0 : _masterVolume * _musicVolume;

  /// True only when a *different*, specific owner already has the
  /// channel — an unowned (`null`) current track (e.g. menu music, which
  /// no screen "owns") is always fair game to take over, which is what
  /// lets a freshly-pushed `DialogueScreen` fade menu music out on entry.
  bool _ownedByOther(Object? owner) =>
      owner != null && _currentOwner != null && _currentOwner != owner;

  Future<void> stopMusic({Object? owner}) async {
    if (_ownedByOther(owner)) return;
    _cancelFade();
    _currentTrack = null;
    _currentOwner = null;
    final generation = ++_intentGeneration;
    await _enqueue(() async {
      if (generation == _intentGeneration) await _musicPlayer.stop();
    });
  }

  Future<void> _enqueue(Future<void> Function() command) {
    _pendingOperations++;
    final next = _commandQueue
        .catchError((_) {})
        .then((_) => command())
        .whenComplete(() => _pendingOperations--);
    _commandQueue = next;
    return next;
  }

  void _markPlaybackStarted() {
    _lastPosition = null;
    _lastPositionChange = DateTime.now();
  }

  void _rampVolume({required double from, required Duration duration}) {
    _cancelFade();
    if (duration <= Duration.zero) {
      unawaited(_musicPlayer.setVolume(_effectiveMusicVolume));
      return;
    }
    const stepMs = 50;
    final steps = (duration.inMilliseconds / stepMs).floor().clamp(1, 1000000);
    var step = 0;
    _fadeTimer = Timer.periodic(const Duration(milliseconds: stepMs), (timer) {
      step++;
      final t = (step / steps).clamp(0.0, 1.0);
      // Re-read the target on every tick so a BGM-slider change also takes
      // effect while the track is still fading in.
      final liveTarget = _effectiveMusicVolume;
      unawaited(_musicPlayer.setVolume(from + (liveTarget - from) * t));
      if (t >= 1.0) {
        timer.cancel();
        if (identical(_fadeTimer, timer)) _fadeTimer = null;
      }
    });
  }

  void _cancelFade() {
    _fadeTimer?.cancel();
    _fadeTimer = null;
  }

  Duration _secondsToDuration(double seconds) =>
      Duration(milliseconds: (seconds * 1000).round());

  Future<void> dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recoveryTimer.cancel();
    unawaited(_positionSubscription.cancel());
    _cancelFade();
    return _musicPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});
