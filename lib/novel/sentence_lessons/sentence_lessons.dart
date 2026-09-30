import 'lesson_01.dart';
import 'lesson_02.dart';
import 'lesson_03.dart';
import 'sentence_lesson.dart';

export 'lesson_01.dart';
export 'lesson_02.dart';
export 'lesson_03.dart';
export 'sentence_lesson.dart';

const sentenceLessons = <SentenceLessonDefinition>[
  sentenceLesson01,
  sentenceLesson02,
  sentenceLesson03,
];

final sentenceLessonById = <String, SentenceLessonDefinition>{
  for (final lesson in sentenceLessons) lesson.id: lesson,
};
