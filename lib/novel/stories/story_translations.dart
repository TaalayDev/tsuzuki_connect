import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

/// Loads the story translation tables exported from the original JavaScript
/// modules. JSON files use the same pivoted shape:
/// `{ "translation.key": { "en": "...", "ru": "..." } }`.
class StoryTranslations {
  static const supportedLanguages = <String>{
    'en',
    'ru',
    'zh',
    'ko',
    'ja',
    'romaji',
  };
  static const fallbackLanguage = 'en';
  static const assetPaths = <String>[
    'assets/translations/Story0.json',
    'assets/translations/Story1.json',
    'assets/translations/Story2.json',
    'assets/translations/Story3.json',
    'assets/translations/Story4.json',
    'assets/translations/Story5.json',
    'assets/translations/Story6.json',
    'assets/translations/Story7.json',
    'assets/translations/SentenceLessons1.json',
    'assets/translations/SentenceLessons2.json',
    'assets/translations/SentenceLessons3.json',
    'assets/translations/VocabularyLessons1.json',
    'assets/translations/VocabularyLessons2.json',
    'assets/translations/VocabularyLessons3.json',
    'assets/translations/VocabularyLessons4.json',
    'assets/translations/VocabularyLessons5.json',
    'assets/translations/VocabularyLessons6.json',
    'assets/translations/VocabularyLessons7.json',
    'assets/translations/VocabularyLessons8.json',
    'assets/translations/VocabularyLessons9.json',
    'assets/translations/VocabularyLessons10.json',
  ];

  final Map<String, Map<String, String>> _translations = {};
  String _language = fallbackLanguage;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  String get language => _language;

  bool containsKey(String key) => _translations.containsKey(key);

  /// A language-first view used by the app's i18n service to expose the same story
  /// strings through its regular `t()` API.
  Map<String, Map<String, String>> get byLanguage {
    final result = <String, Map<String, String>>{
      for (final language in supportedLanguages) language: <String, String>{},
    };
    for (final entry in _translations.entries) {
      for (final translation in entry.value.entries) {
        if (supportedLanguages.contains(translation.key)) {
          result[translation.key]![entry.key] = translation.value;
        }
      }
    }
    return result;
  }

  Future<void> load({AssetBundle? bundle}) async {
    final source = bundle ?? rootBundle;
    final loaded = <String, Map<String, String>>{};

    for (final path in assetPaths) {
      final raw = await source.loadString(path);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in json.entries) {
        final values = entry.value as Map<String, dynamic>;
        loaded[entry.key] = <String, String>{
          for (final translation in values.entries)
            if (translation.value is String)
              translation.key: translation.value as String,
        };
      }
    }

    _translations
      ..clear()
      ..addAll(loaded);
    _isLoaded = true;
  }

  void setLanguage(String language) {
    _language = supportedLanguages.contains(language)
        ? language
        : fallbackLanguage;
  }

  String t(String key, {String? language}) {
    if (key.isEmpty) return '';
    final values = _translations[key];
    if (values == null) return key;
    final selectedLanguage = language ?? _language;
    return values[selectedLanguage] ?? values[fallbackLanguage] ?? key;
  }
}

final storyTranslations = StoryTranslations();
