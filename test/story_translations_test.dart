import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/novel/stories/stories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loads JSON story translations and resolves the selected language',
    () async {
      await storyTranslations.load();
      storyTranslations.setLanguage('ru');

      expect(tr('s0.title'), 's0.title');
      expect(getStory0()['title'], 's0.title');
      expect(getStory6()['title'], 's6.title');
      expect(
        storyTranslations.t('s0.title', language: 'ru'),
        'Первый день занятий',
      );
      expect(tr('missing.translation.key'), 'missing.translation.key');
    },
  );
}
