import '../dialogue_builder.dart';

enum VocabularyLessonLevel { beginner, intermediate, advanced }

class VocabularyLessonDefinition {
  const VocabularyLessonDefinition({
    required this.id,
    required this.number,
    required this.level,
    required this.titleKey,
    required this.subtitleKey,
    required this.descriptionKey,
    required this.estimatedTime,
    required this.cefrFocus,
    required this.wordIds,
    required this.storyFactory,
  });

  final String id;
  final int number;
  final VocabularyLessonLevel level;
  final String titleKey;
  final String subtitleKey;
  final String descriptionKey;
  final String estimatedTime;
  final String cefrFocus;
  final List<String> wordIds;
  final StoryData Function() storyFactory;

  int get expectedWordCount => number == 1 ? 5 : (number == 2 ? 8 : 10);

  Map<String, dynamic> toCatalogEntry() => <String, dynamic>{
    'id': id,
    'title': titleKey,
    'subtitle': subtitleKey,
    'description': descriptionKey,
    'estimatedTime': estimatedTime,
    'cefrFocus': cefrFocus,
    'level': level.name,
    'wordCount': wordIds.length,
  };
}
