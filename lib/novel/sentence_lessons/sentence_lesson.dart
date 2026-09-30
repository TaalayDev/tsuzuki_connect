import '../dialogue_builder.dart';

enum SentenceLessonLevel { beginner, elementary, intermediate }

/// One "sentences" topic: a short class on a single sentence pattern followed
/// by real-situation practice. Mirrors `VocabularyLessonDefinition`, but a
/// sentence lesson teaches [patternKeys] (translation keys naming each
/// sentence pattern) instead of a list of words.
class SentenceLessonDefinition {
  const SentenceLessonDefinition({
    required this.id,
    required this.number,
    required this.level,
    required this.titleKey,
    required this.subtitleKey,
    required this.descriptionKey,
    required this.estimatedTime,
    required this.cefrFocus,
    required this.patternKeys,
    required this.storyFactory,
  });

  final String id;
  final int number;
  final SentenceLessonLevel level;
  final String titleKey;
  final String subtitleKey;
  final String descriptionKey;
  final String estimatedTime;
  final String cefrFocus;
  final List<String> patternKeys;
  final StoryData Function() storyFactory;

  Map<String, dynamic> toCatalogEntry() => <String, dynamic>{
    'id': id,
    'title': titleKey,
    'subtitle': subtitleKey,
    'description': descriptionKey,
    'estimatedTime': estimatedTime,
    'cefrFocus': cefrFocus,
    'level': level.name,
    'patternCount': patternKeys.length,
  };
}
