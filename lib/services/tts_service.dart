import 'package:flutter_tts/flutter_tts.dart';

/// Reads Japanese lesson/vocab text aloud.
///
/// Mirrors `js/systems/TTS.js`: on iOS/macOS `flutter_tts` is backed by the
/// same native `AVSpeechSynthesizer` the old WKWebView `speechSynthesis`
/// call used, so voice lists carry over directly. Always speaks Japanese
/// (the language being taught), regardless of the app's UI language.
class TtsService {
  TtsService();

  static const _defaultLang = 'ja-JP';

  /// Short sentence for the settings screen to preview the selected voice.
  static const sampleText = 'こんにちは。これが私の声です。';

  /// The settings slider runs from 0.5 to 1.5 (1.0 = normal). `flutter_tts`
  /// wants 0.0-1.0 with 0.5 as the natural speed on both iOS and Android, and
  /// a slightly calmer pace suits learners, so the slider is scaled down.
  static const _rateScale = 0.45;

  final FlutterTts _tts = FlutterTts();

  String? _preferredVoiceName;
  double _rate = 1.0;
  double _pitch = 1.0;
  double _volume = 0.8;
  Future<void>? _voiceSetup;

  Future<List<Map<String, String>>> getJapaneseVoices() async {
    final voices = await _tts.getVoices as List<dynamic>? ?? const [];
    return voices
        .cast<Map<dynamic, dynamic>>()
        .map((v) => v.map((k, val) => MapEntry(k.toString(), val.toString())))
        .where(_isJapanese)
        .toList();
  }

  bool _isJapanese(Map<String, String> voice) {
    final locale = (voice['locale'] ?? '').toLowerCase().replaceAll('_', '-');
    return locale == 'ja' || locale.startsWith('ja-');
  }

  Future<void> speak(String text) async {
    final clean = _cleanForSpeech(text);
    if (clean.isEmpty) return;

    await _tts.stop();
    await (_voiceSetup ??= _configureJapaneseVoice());
    await _tts.setSpeechRate((_rate * _rateScale).clamp(0.1, 1.0));
    await _tts.setPitch(_pitch);
    await _tts.setVolume(_volume);
    await _tts.speak(clean);
  }

  Future<void> _configureJapaneseVoice() async {
    // Always select the language first: even when no voice list is available
    // (web, some Android engines) the engine then still speaks Japanese.
    await _tts.setLanguage(_defaultLang);
    final voices = await getJapaneseVoices();
    if (voices.isEmpty) return;

    Map<String, String>? selected;
    final preferred = _preferredVoiceName?.toLowerCase();
    if (preferred != null && preferred.isNotEmpty) {
      for (final voice in voices) {
        if ((voice['name'] ?? '').toLowerCase() == preferred) {
          selected = voice;
          break;
        }
      }
    }
    // A saved voice from before the app taught Japanese (an English voice) is
    // not in this list, so it falls through to the best Japanese voice.
    selected ??= _bestJapaneseVoice(voices);

    final name = selected['name'];
    final locale = selected['locale'];
    if (name == null || locale == null) return;
    await _tts.setLanguage(locale);
    await _tts.setVoice({'name': name, 'locale': locale});
  }

  Map<String, String> _bestJapaneseVoice(List<Map<String, String>> voices) {
    // Higher-quality downloadable voices sound far more natural for Japanese.
    int rank(Map<String, String> voice) {
      final name = (voice['name'] ?? '').toLowerCase();
      if (name.contains('premium')) return 0;
      if (name.contains('enhanced')) return 1;
      if (name.contains('kyoko') || name.contains('o-ren')) return 2;
      return 3;
    }

    final sorted = [...voices]..sort((a, b) => rank(a).compareTo(rank(b)));
    return sorted.first;
  }

  Future<void> stop() => _tts.stop();

  void setPreferredVoice(String? voiceName) {
    if (_preferredVoiceName == voiceName) return;
    _preferredVoiceName = voiceName;
    _voiceSetup = null;
  }

  String? get preferredVoice => _preferredVoiceName;

  /// 0.5-1.5, matches the Settings slider range in the JS version.
  void setRate(double rate) {
    if (rate > 0) _rate = rate;
  }

  double get rate => _rate;

  void setPitch(double pitch) {
    if (pitch > 0) _pitch = pitch;
  }

  double get pitch => _pitch;

  void setVolume(double volume) => _volume = volume.clamp(0.0, 1.0);

  double get volume => _volume;

  /// Drops marks the synthesizer would read out or stumble on: quote
  /// brackets, the "~" used in grammar patterns and the middle dot.
  String _cleanForSpeech(String text) {
    return text
        .replaceAll(RegExp('[「」『』“”"]'), '')
        .replaceAll(RegExp('[〜～~]'), '')
        .replaceAll('・', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
