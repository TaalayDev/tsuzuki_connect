import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/services/i18n_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads UI and story translations from their asset folders', () async {
    final i18n = I18nService();
    await i18n.load();
    i18n.setLanguage('ru');

    expect(i18n.t('menu.story'), 'История');
    expect(i18n.t('s0.title'), 'Первый день занятий');
    expect(
      i18n.supportedLanguages,
      containsAll(<String>['en', 'ru', 'zh', 'ko', 'ja', 'romaji']),
    );
  });
}
