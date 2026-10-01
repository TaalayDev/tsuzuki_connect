import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/models/dialogue_line.dart';
import 'package:tsuzuki_connect/models/story.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await storyTranslations.load();
    storyTranslations.setLanguage('en');
  });

  test('loads all chapters from Dart story builders', () async {
    final service = ContentService();
    final stories = await Future.wait(<Future<Story>>[
      for (var index = 0; index < 8; index++)
        service.loadStory(ContentCategory.chapter, 'story$index'),
    ]);

    expect(stories, hasLength(8));
    expect(stories.map((story) => story.id), <String>[
      'story0',
      'story1',
      'story2',
      'story3',
      'story4',
      'story5',
      'story6',
      'story7',
    ]);
    expect(
      stories.fold<int>(0, (sum, story) => sum + story.scenes.length),
      200,
    );
  });

  test('builds the chapter catalog without chapter JSON assets', () async {
    final catalog = await ContentService().loadCatalog(ContentCategory.chapter);

    expect(catalog, hasLength(8));
    expect(catalog.first['id'], 'story0');
    expect(catalog.first['cefrFocus'], 'A1');
    expect(catalog.last['cefrFocus'], 'B1');
  });

  test('story text keys resolve Japanese and romaji', () async {
    var translatedLineCount = 0;

    for (var index = 0; index < 8; index++) {
      final story = await ContentService().loadStory(
        ContentCategory.chapter,
        'story$index',
      );
      for (final line
          in story.scenes
              .expand((scene) => scene.lines)
              .where(
                (line) => line is DialogueTextLine || line is NarrationLine,
              )) {
        final raw = switch (line) {
          DialogueTextLine(text: final text) => text,
          NarrationLine(text: final text) => text,
          _ => throw StateError('Unexpected story line'),
        };
        final key = raw.startsWith('(') && raw.endsWith(')')
            ? raw.substring(1, raw.length - 1)
            : raw;
        if (!storyTranslations.containsKey(key)) continue;
        translatedLineCount++;
        expect(storyTranslations.t(key, language: 'ja'), isNot(key));
        expect(storyTranslations.t(key, language: 'romaji'), isNot(key));
      }
    }

    expect(translatedLineCount, greaterThan(1500));
    expect(
      storyTranslations.t('s1.s1.splash', language: 'ja'),
      '冷たい水を顔にバシャッとかけ、緊張を落ち着かせようとする。',
    );
    expect(
      storyTranslations.t('s1.s1.splash', language: 'romaji'),
      'Tsumetai mizu o kao ni bashatto kake, kinchou o ochitsukaseyou to suru.',
    );
  });
}
