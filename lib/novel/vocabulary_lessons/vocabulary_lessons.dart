import 'lesson_01.dart';
import 'lesson_02.dart';
import 'lesson_03.dart';
import 'lesson_04.dart';
import 'lesson_05.dart';
import 'lesson_06.dart';
import 'lesson_07.dart';
import 'lesson_08.dart';
import 'lesson_09.dart';
import 'lesson_10.dart';
import 'vocabulary_lesson.dart';

export 'lesson_01.dart';
export 'lesson_02.dart';
export 'lesson_03.dart';
export 'lesson_04.dart';
export 'lesson_05.dart';
export 'lesson_06.dart';
export 'lesson_07.dart';
export 'lesson_08.dart';
export 'lesson_09.dart';
export 'lesson_10.dart';
export 'vocabulary_lesson.dart';

const vocabularyLessons = <VocabularyLessonDefinition>[
  vocabularyLesson01,
  vocabularyLesson02,
  vocabularyLesson03,
  vocabularyLesson04,
  vocabularyLesson05,
  vocabularyLesson06,
  vocabularyLesson07,
  vocabularyLesson08,
  vocabularyLesson09,
  vocabularyLesson10,
];

final vocabularyLessonById = <String, VocabularyLessonDefinition>{
  for (final lesson in vocabularyLessons) lesson.id: lesson,
};
