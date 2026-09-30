import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';
import 'package:tsuzuki_connect/novel/vocabulary_lessons/vocabulary_lessons.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

import 'lesson_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await storyTranslations.load();
  });

  test('lessons are numbered in order with unique ids', () {
    expect(vocabularyLessons, isNotEmpty);
    for (final entry in vocabularyLessons.indexed) {
      expect(entry.$2.number, entry.$1 + 1);
    }
    expect(
      vocabularyLessons.map((lesson) => lesson.id).toSet(),
      hasLength(vocabularyLessons.length),
    );
  });

  test('every lesson introduces the expected number of valid words', () async {
    final vocabulary = await ContentService().loadVocabulary();
    final vocabularyIds = vocabulary.map((word) => word.id).toSet();
    final seen = <String>{};

    for (final lesson in vocabularyLessons) {
      expect(
        lesson.wordIds,
        hasLength(lesson.expectedWordCount),
        reason: lesson.id,
      );
      expect(lesson.wordIds.toSet(), hasLength(lesson.wordIds.length));
      for (final wordId in lesson.wordIds) {
        expect(vocabularyIds, contains(wordId), reason: '${lesson.id} $wordId');
        expect(seen.add(wordId), isTrue, reason: 'repeated word $wordId');
      }
    }
  });

  test('the catalog lists every lesson', () async {
    final catalog = await ContentService().loadCatalog(
      ContentCategory.vocabLesson,
    );

    expect(catalog.map((entry) => entry['id']), [
      for (final lesson in vocabularyLessons) lesson.id,
    ]);
    for (final entry in catalog) {
      expect(entry['wordCount'], greaterThanOrEqualTo(5));
    }
  });

  test('all lesson choices point to scenes and text resolves in every '
      'language', () async {
    final service = ContentService();
    for (final lesson in vocabularyLessons) {
      final story = await service.loadStory(
        ContentCategory.vocabLesson,
        lesson.id,
      );

      expect(story.id, lesson.id);
      expect(story.scenes.length, greaterThan(10), reason: lesson.id);
      expect(expectStoryIsValid(story), greaterThan(0), reason: lesson.id);
    }
  });
}
