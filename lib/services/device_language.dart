import 'dart:ui' show Locale;

/// Resolves the app's initial UI language from the device preference list.
///
/// Detection is only used when no language has ever been persisted. Once the
/// user changes language in Settings, that saved choice always wins on future
/// launches.
class DeviceLanguage {
  DeviceLanguage._();

  static const selectableLanguages = ['en', 'ru', 'zh', 'ko', 'ja'];
  static const _selectableLanguageSet = {'en', 'ru', 'zh', 'ko', 'ja'};

  static String detect(List<Locale> preferredLocales) {
    for (final locale in preferredLocales) {
      final languageCode = locale.languageCode.toLowerCase();
      if (_selectableLanguageSet.contains(languageCode)) {
        return languageCode;
      }
    }
    return 'en';
  }
}
