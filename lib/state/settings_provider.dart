import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';
import '../services/save_service.dart';
import '../services/tts_service.dart';
import 'i18n_provider.dart';

/// Mirrors `Game.getDefaultSettings()` / `Game.applySettings()` in the JS
/// version: font size, language, subtitle/transcription toggles, audio
/// volumes, and TTS voice/rate/pitch.
class AppSettings {
  const AppSettings({
    this.language = 'en',
    this.fontSize = 'medium',
    this.showSubtitles = true,
    this.showTranscription = true,
    this.showChoiceTranslation = false,
    this.masterVolume = 0.8,
    this.musicVolume = 0.7,
    this.sfxVolume = 0.6,
    this.ttsVoice = '',
    this.ttsRate = 0.0,
    this.ttsPitch = 1.0,
    this.profileInitialized = false,
    this.playerName = '',
    this.playerLevel = 'beginner',
  });

  final String language;
  final String fontSize;
  final bool showSubtitles;
  final bool showTranscription;
  final bool showChoiceTranslation;
  final double masterVolume;
  final double musicVolume;
  final double sfxVolume;
  final String ttsVoice;
  final double ttsRate;
  final double ttsPitch;

  /// `Game.state.settings.profileInitialized`/`playerName`/`playerLevel` —
  /// written once by `setPlayerProfile()` when the character-creation
  /// screen is submitted. `playerLevel` is one of `beginner`/`some`/
  /// `intermediate`, matching `data-level` in `#character-creation` — it
  /// drives both onboarding routing (`firstLessonIdForLevel()`/
  /// `firstVocabLessonIdForLevel()`) and the vocab-highlight target/known
  /// split (`SceneManager.getPlayerLevel()`).
  final bool profileInitialized;
  final String playerName;
  final String playerLevel;

  AppSettings copyWith({
    String? language,
    String? fontSize,
    bool? showSubtitles,
    bool? showTranscription,
    bool? showChoiceTranslation,
    double? masterVolume,
    double? musicVolume,
    double? sfxVolume,
    String? ttsVoice,
    double? ttsRate,
    double? ttsPitch,
    bool? profileInitialized,
    String? playerName,
    String? playerLevel,
  }) {
    return AppSettings(
      language: language ?? this.language,
      fontSize: fontSize ?? this.fontSize,
      showSubtitles: showSubtitles ?? this.showSubtitles,
      showTranscription: showTranscription ?? this.showTranscription,
      showChoiceTranslation: showChoiceTranslation ?? this.showChoiceTranslation,
      masterVolume: masterVolume ?? this.masterVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      ttsVoice: ttsVoice ?? this.ttsVoice,
      ttsRate: ttsRate ?? this.ttsRate,
      ttsPitch: ttsPitch ?? this.ttsPitch,
      profileInitialized: profileInitialized ?? this.profileInitialized,
      playerName: playerName ?? this.playerName,
      playerLevel: playerLevel ?? this.playerLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'fontSize': fontSize,
    'showSubtitles': showSubtitles,
    'showTranscription': showTranscription,
    'showChoiceTranslation': showChoiceTranslation,
    'masterVolume': masterVolume,
    'musicVolume': musicVolume,
    'sfxVolume': sfxVolume,
    'ttsVoice': ttsVoice,
    'ttsRate': ttsRate,
    'ttsPitch': ttsPitch,
    'profileInitialized': profileInitialized,
    'playerName': playerName,
    'playerLevel': playerLevel,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    language: json['language'] as String? ?? 'en',
    fontSize: json['fontSize'] as String? ?? 'medium',
    showSubtitles: json['showSubtitles'] as bool? ?? true,
    showTranscription: json['showTranscription'] as bool? ?? true,
    showChoiceTranslation: json['showChoiceTranslation'] as bool? ?? false,
    masterVolume: (json['masterVolume'] as num?)?.toDouble() ?? 0.8,
    musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.7,
    sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 0.6,
    ttsVoice: json['ttsVoice'] as String? ?? '',
    ttsRate: (json['ttsRate'] as num?)?.toDouble() ?? 0.0,
    ttsPitch: (json['ttsPitch'] as num?)?.toDouble() ?? 1.0,
    profileInitialized: json['profileInitialized'] as bool? ?? false,
    playerName: json['playerName'] as String? ?? '',
    playerLevel: json['playerLevel'] as String? ?? 'beginner',
  );
}

class SettingsNotifier extends Notifier<AppSettings> {
  late SaveService _saveService;
  late TtsService _ttsService;
  late AudioService _audioService;

  @override
  AppSettings build() {
    _saveService = ref.read(saveServiceProvider);
    _ttsService = ref.read(ttsServiceProvider);
    _audioService = ref.read(audioServiceProvider);
    final stored = _saveService.settings;
    final settings = stored.isEmpty ? const AppSettings() : AppSettings.fromJson(stored);
    _applyToServices(settings);
    return settings;
  }

  void update(AppSettings Function(AppSettings) updater) {
    final next = updater(state);
    state = next;
    _applyToServices(next);
    _saveService.saveSettings(next.toJson());
  }

  void _applyToServices(AppSettings settings) {
    _ttsService
      ..setPreferredVoice(settings.ttsVoice.isEmpty ? null : settings.ttsVoice)
      ..setRate(settings.ttsRate)
      ..setPitch(settings.ttsPitch)
      ..setVolume(settings.masterVolume);
    _audioService.setVolumes(master: settings.masterVolume, music: settings.musicVolume);
    ref.read(i18nProvider).setLanguage(settings.language);
  }
}

final saveServiceProvider = Provider<SaveService>((ref) {
  throw UnimplementedError('Overridden in main() after SaveService.create()');
});

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
