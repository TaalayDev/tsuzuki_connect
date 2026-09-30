import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../novel/stories/story_translations.dart';

/// Loads and looks up UI + story/lesson translation strings.
///
/// Mirrors `js/systems/I18n.js`. UI strings retain their language-first
/// `{ lang: { key: text } }` file, while story strings are loaded from the
/// pivoted `{ key: { lang: text } }` files in `assets/translations/`.
///
/// Every `text`/`title`/`subtitle`/... field coming out of
/// `ContentService` (see `lib/models/dialogue_line.dart`) is a translation
/// *key* like `l17.s0.alex_intro`, not resolved text — call [t] on it
/// before displaying.
class I18nService {
  final Map<String, Map<String, String>> _translations = {};
  String _language = 'en';

  static const fallbackLanguage = 'en';

  String get language => _language;

  List<String> get supportedLanguages =>
      _translations.keys.toList(growable: false);

  Future<void> load() async {
    final ui = await _loadJson('assets/i18n/ui_translations.json');
    _merge(ui);
    await storyTranslations.load();
    _mergeStoryTranslations(storyTranslations.byLanguage);
  }

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  void _merge(Map<String, dynamic> byLang) {
    for (final entry in byLang.entries) {
      final target = _translations.putIfAbsent(entry.key, () => {});
      final keys = (entry.value as Map<String, dynamic>);
      for (final kv in keys.entries) {
        target[kv.key] = kv.value as String;
      }
    }
  }

  void _mergeStoryTranslations(Map<String, Map<String, String>> byLanguage) {
    for (final entry in byLanguage.entries) {
      _translations.putIfAbsent(entry.key, () => {}).addAll(entry.value);
    }
  }

  void setLanguage(String language) {
    _language = _translations.containsKey(language)
        ? language
        : fallbackLanguage;
    storyTranslations.setLanguage(_language);
  }

  /// Returns the translated string for [key] in the current language,
  /// falling back to English, then to the raw key itself — matching
  /// `tr()`'s "return the key unchanged if nothing resolves" behavior in
  /// the JS version, so untranslated content never renders blank.
  ///
  /// Exported content can contain thought keys wrapped in literal
  /// parentheses. On a direct miss we retry without the parentheses and
  /// re-wrap the translated value.
  ///
  /// Pass [language] to resolve [key] in a *specific* language instead of
  /// the current UI language. Dialogue lines use the same key for their
  /// Japanese text, romaji, and selected-language translation.
  String t(String key, {String? language}) {
    if (key.isEmpty) return '';
    final lang = language ?? _language;
    final direct =
        _translations[lang]?[key] ?? _translations[fallbackLanguage]?[key];
    if (direct != null) return direct;

    if (key.startsWith('(') && key.endsWith(')') && key.length > 2) {
      final inner = key.substring(1, key.length - 1);
      final resolvedInner =
          _translations[lang]?[inner] ??
          _translations[fallbackLanguage]?[inner];
      if (resolvedInner != null) return '($resolvedInner)';
    }

    return key;
  }
}
