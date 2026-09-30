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
import 'sentence_lesson.dart';

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
export 'sentence_lesson.dart';

const sentenceLessons = <SentenceLessonDefinition>[
  sentenceLesson01,
  sentenceLesson02,
  sentenceLesson03,
  sentenceLesson04,
  sentenceLesson05,
  sentenceLesson06,
  sentenceLesson07,
  sentenceLesson08,
  sentenceLesson09,
  sentenceLesson10,
  sentenceLesson11,
  sentenceLesson12,
  sentenceLesson13,
  sentenceLesson14,
  sentenceLesson15,
  sentenceLesson16,
  sentenceLesson17,
  sentenceLesson18,
];

final sentenceLessonById = <String, SentenceLessonDefinition>{
  for (final lesson in sentenceLessons) lesson.id: lesson,
};
