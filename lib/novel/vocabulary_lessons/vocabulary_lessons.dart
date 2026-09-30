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
import 'lesson_11.dart';
import 'lesson_12.dart';
import 'lesson_13.dart';
import 'lesson_14.dart';
import 'lesson_15.dart';
import 'lesson_16.dart';
import 'lesson_17.dart';
import 'lesson_18.dart';
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
export 'lesson_11.dart';
export 'lesson_12.dart';
export 'lesson_13.dart';
export 'lesson_14.dart';
export 'lesson_15.dart';
export 'lesson_16.dart';
export 'lesson_17.dart';
export 'lesson_18.dart';
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
  vocabularyLesson11,
  vocabularyLesson12,
  vocabularyLesson13,
  vocabularyLesson14,
  vocabularyLesson15,
  vocabularyLesson16,
  vocabularyLesson17,
  vocabularyLesson18,
];

final vocabularyLessonById = <String, VocabularyLessonDefinition>{
  for (final lesson in vocabularyLessons) lesson.id: lesson,
};
