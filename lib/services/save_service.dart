import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Key-value persistence for settings, progress flags, and save slots.
///
/// Mirrors the `localStorage` usage scattered across `js/engine/Game.js`
/// and `js/main.js` (settings object, `completedStories`,
/// `completedLessons`, `completedVocabLessons`, `vocabLearned`, autosave).
class SaveService {
  SaveService(this._prefs);

  static Future<SaveService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SaveService(prefs);
  }

  final SharedPreferences _prefs;

  static const _settingsKey = 'ce.settings';
  static const _progressKey = 'ce.progress';
  static const _autosaveKey = 'ce.autosave';

  Map<String, dynamic> readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic> get settings => readJson(_settingsKey);
  Future<void> saveSettings(Map<String, dynamic> value) => writeJson(_settingsKey, value);

  Map<String, dynamic> get progress => readJson(_progressKey);
  Future<void> saveProgress(Map<String, dynamic> value) => writeJson(_progressKey, value);

  Map<String, dynamic>? get autosave {
    final raw = _prefs.getString(_autosaveKey);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveAutosave(Map<String, dynamic> value) => writeJson(_autosaveKey, value);
  Future<void> clearAutosave() => _prefs.remove(_autosaveKey);
}
