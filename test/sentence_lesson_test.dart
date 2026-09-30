import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/novel/sentence_lessons/sentence_lessons.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';
import 'package:tsuzuki_connect/services/access_policy.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

import 'lesson_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await storyTranslations.load();
  });

  test('lessons are numbered in order with unique ids', () {
    expect(sentenceLessons, isNotEmpty);
    for (final entry in sentenceLessons.indexed) {
      final number = entry.$1 + 1;
      expect(entry.$2.number, number);
      expect(
        entry.$2.id,
        'sentence_lesson_${number.toString().padLeft(2, '0')}',
      );
    }
  });

  test('every lesson names the sentence patterns it teaches', () {
    for (final lesson in sentenceLessons) {
      expect(lesson.patternKeys, isNotEmpty, reason: lesson.id);
      for (final key in [
        lesson.titleKey,
        lesson.subtitleKey,
        lesson.descriptionKey,
        ...lesson.patternKeys,
      ]) {
        expect(storyTranslations.containsKey(key), isTrue, reason: key);
        for (final language in lessonLanguages) {
          expect(
            storyTranslations.t(key, language: language),
            isNot(key),
            reason: '$key ($language)',
          );
        }
      }
    }
  });

  test('the catalog lists every lesson', () async {
    final catalog = await ContentService().loadCatalog(ContentCategory.lesson);

    expect(catalog.map((entry) => entry['id']), [
      for (final lesson in sentenceLessons) lesson.id,
    ]);
    expect(
      catalog.first['patternCount'],
      sentenceLessons.first.patternKeys.length,
    );
  });

  test('all lesson choices point to scenes and text resolves in every '
      'language', () async {
    final service = ContentService();
    for (final lesson in sentenceLessons) {
      final story = await service.loadStory(ContentCategory.lesson, lesson.id);

      expect(story.id, lesson.id);
      expect(story.scenes.length, greaterThan(10), reason: lesson.id);
      expect(expectStoryIsValid(story), greaterThan(0), reason: lesson.id);
    }
  });

  test('new players start with the first sentence lesson', () {
    for (final level in ['beginner', 'some', 'intermediate']) {
      expect(
        sentenceLessonById.keys,
        contains(AccessPolicy.firstLessonIdForLevel(level)),
      );
    }
  });

  test('the first ten sentence lessons stay in the free tier', () {
    final order = [for (final lesson in sentenceLessons) lesson.id];
    for (final id in order) {
      expect(AccessPolicy.isLessonPaidTier(id, order), isFalse);
    }
  });
}
