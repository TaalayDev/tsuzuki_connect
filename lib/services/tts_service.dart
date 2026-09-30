import 'package:flutter_tts/flutter_tts.dart';

/// Reads English lesson/vocab text aloud.
///
/// Mirrors `js/systems/TTS.js`: on iOS/macOS `flutter_tts` is backed by the
/// same native `AVSpeechSynthesizer` the old WKWebView `speechSynthesis`
/// call used, so behavior (voice list, rate/pitch range) carries over
/// directly. Always speaks English (the language being taught), regardless
/// of the app's UI language.
class TtsService {
  TtsService();

  static const _defaultLang = 'en-US';

  final FlutterTts _tts = FlutterTts();

  String? _preferredVoiceName;
  double _rate = 0.0; // matches TTS.js default
  double _pitch = 1.0;
  double _volume = 0.8;
  Future<void>? _voiceSetup;

  Future<List<Map<String, String>>> getEnglishVoices() async {
    final voices = await _tts.getVoices as List<dynamic>? ?? const [];
    return voices
        .cast<Map<dynamic, dynamic>>()
        .map((v) => v.map((k, val) => MapEntry(k.toString(), val.toString())))
        .where((v) => (v['locale'] ?? '').toLowerCase().startsWith('en'))
        .toList();
  }

  Future<void> speak(String text) async {
    final clean = _cleanForSpeech(text);
    if (clean.isEmpty) return;

    await _tts.stop();
    await (_voiceSetup ??= _configureEnglishVoice());
    await _tts.setSpeechRate(_rate);
    await _tts.setPitch(_pitch);
    await _tts.setVolume(_volume);
    await _tts.speak(clean);
  }

  Future<void> _configureEnglishVoice() async {
    await _tts.setLanguage(_defaultLang);
    final voices = await getEnglishVoices();
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
    selected ??= _bestEnglishVoice(voices);

    final name = selected['name'];
    final locale = selected['locale'];
    if (name == null || locale == null) return;
    await _tts.setLanguage(locale);
    await _tts.setVoice({'name': name, 'locale': locale});
  }

  Map<String, String> _bestEnglishVoice(List<Map<String, String>> voices) {
    int rank(Map<String, String> voice) {
      final locale = (voice['locale'] ?? '').toLowerCase().replaceAll('_', '-');
      if (locale == 'en-us') return 0;
      if (locale == 'en-gb') return 1;
      if (locale.startsWith('en-')) return 2;
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

  String _cleanForSpeech(String text) {
    return text
        .replaceAll(RegExp('[""]'), '')
        .replaceAll(RegExp("['']"), "'")
        .trim();
  }
}
