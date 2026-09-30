import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/models/dialogue_line.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';
import 'package:tsuzuki_connect/novel/vocabulary_lessons/vocabulary_lessons.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await storyTranslations.load();
  });

  test('lesson 1 has five valid new vocabulary words', () async {
    final service = ContentService();
    final vocabulary = await service.loadVocabulary();
    final vocabularyIds = vocabulary.map((word) => word.id).toSet();

    expect(vocabularyLesson01.wordIds, hasLength(5));
    expect(vocabularyLesson01.wordIds.toSet(), hasLength(5));
    expect(
      vocabularyLesson01.wordIds.where(
        (wordId) => !vocabularyIds.contains(wordId),
      ),
      isEmpty,
    );
  });

  test(
    'loads lesson 1 and exposes it through the vocabulary catalog',
    () async {
      final service = ContentService();
      final catalog = await service.loadCatalog(ContentCategory.vocabLesson);
      final story = await service.loadStory(
        ContentCategory.vocabLesson,
        vocabularyLesson01.id,
      );

      expect(catalog, hasLength(1));
      expect(catalog.single['id'], vocabularyLesson01.id);
      expect(catalog.single['wordCount'], 5);
      expect(story.id, vocabularyLesson01.id);
      expect(story.scenes.length, greaterThan(10));
    },
  );

  test(
    'all lesson choices point to scenes and text resolves in Japanese',
    () async {
      final story = await ContentService().loadStory(
        ContentCategory.vocabLesson,
        vocabularyLesson01.id,
      );
      final sceneTargets = <String>{
        for (final scene in story.scenes) ...<String>[scene.id, scene.label],
      };
      var choiceCount = 0;

      for (final line in story.scenes.expand((scene) => scene.lines)) {
        final keys = switch (line) {
          DialogueTextLine(text: final text) => <String>[text],
          NarrationLine(text: final text) => <String>[text],
          TitleCardLine(title: final title, subtitle: final subtitle) =>
            <String>[title, subtitle],
          ChoiceLine(choices: final choices) => <String>[
            for (final choice in choices) choice.text,
          ],
          _ => const <String>[],
        };

        for (final key in keys.where((value) => value.isNotEmpty)) {
          expect(storyTranslations.containsKey(key), isTrue, reason: key);
          expect(storyTranslations.t(key, language: 'ja'), isNot(key));
          expect(storyTranslations.t(key, language: 'romaji'), isNot(key));
        }

        if (line case ChoiceLine(choices: final choices)) {
          choiceCount += choices.length;
          for (final choice in choices) {
            expect(sceneTargets, contains(choice.next));
          }
        }
      }

      expect(choiceCount, 12);
    },
  );
}
