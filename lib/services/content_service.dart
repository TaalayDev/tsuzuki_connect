import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/story.dart';
import '../models/vocab_word.dart';
import '../novel/sentence_lessons/sentence_lessons.dart';
import '../novel/stories/stories.dart';
import '../novel/vocabulary_lessons/vocabulary_lessons.dart';

/// Which registry a story/lesson id belongs to — mirrors the three separate
/// content registries in the JS project. Chapters now come from Dart sources;
/// the two lesson categories retain their separate compiled registries.
enum ContentCategory { lesson, vocabLesson, chapter }

/// Loads chapters, sentence lessons and vocabulary lessons directly from the
/// Dart builders under `lib/novel/`. Level-based vocabulary dictionaries are
/// loaded from `assets/vocabulary/`.
class ContentService {
  static final Map<String, StoryData Function()> _chapterFactories = {
    'story0': getStory0,
    'story1': getStory1,
    'story2': getStory2,
    'story3': getStory3,
    'story4': getStory4,
    'story5': getStory5,
    'story6': getStory6,
    'story7': getStory7,
  };

  final Map<String, Story> _storyCache = {};
  List<VocabWord>? _vocabCache;

  /// [id] is the topic id from the matching catalog (e.g. `sentence_lesson_01`
  /// for a sentence lesson, `vocab_lesson_01` for a vocabulary lesson,
  /// `story0` for a chapter).
  Future<Story> loadStory(ContentCategory category, String id) async {
    final cacheKey = '${category.name}:$id';
    final cached = _storyCache[cacheKey];
    if (cached != null) return cached;

    final story = switch (category) {
      ContentCategory.chapter => _loadChapter(id),
      ContentCategory.vocabLesson => _loadVocabularyLesson(id),
      ContentCategory.lesson => _loadSentenceLesson(id),
    };
    _storyCache[cacheKey] = story;
    return story;
  }

  Story _loadChapter(String id) {
    final factory = _chapterFactories[id];
    if (factory == null) {
      throw ArgumentError.value(id, 'id', 'Unknown Dart story');
    }
    return Story.fromJson(_normalizeChapter(id, factory()));
  }

  Story _loadVocabularyLesson(String id) {
    final lesson = vocabularyLessonById[id];
    if (lesson == null) {
      throw ArgumentError.value(id, 'id', 'Unknown Dart vocabulary lesson');
    }
    if (lesson.wordIds.length != lesson.expectedWordCount) {
      throw StateError(
        '${lesson.id} must introduce ${lesson.expectedWordCount} words, '
        'but defines ${lesson.wordIds.length}',
      );
    }
    return Story.fromJson(_normalizeChapter(id, lesson.storyFactory()));
  }

  Story _loadSentenceLesson(String id) {
    final lesson = sentenceLessonById[id];
    if (lesson == null) {
      throw ArgumentError.value(id, 'id', 'Unknown Dart sentence lesson');
    }
    if (lesson.patternKeys.isEmpty) {
      throw StateError('${lesson.id} must teach at least one sentence pattern');
    }
    return Story.fromJson(_normalizeChapter(id, lesson.storyFactory()));
  }

  Map<String, dynamic> _normalizeChapter(String id, StoryData source) {
    final scenes = (source['scenes'] as List<dynamic>)
        .map((value) {
          final scene = value as Map<String, dynamic>;
          final lines = <Map<String, dynamic>>[];
          for (final value in scene['lines'] as List<dynamic>) {
            final normalized = _normalizeChapterLine(
              value as Map<String, dynamic>,
            );
            if (normalized != null) lines.add(normalized);
          }
          return <String, dynamic>{
            'id': scene['id'],
            'label': scene['label'] ?? scene['id'],
            'lines': lines,
          };
        })
        .toList(growable: false);

    return <String, dynamic>{
      'id': id,
      'title': source['title'] ?? '',
      'subtitle': source['titleJp'] ?? '',
      'description': source['description'] ?? '',
      'estimatedTime': source['estimatedTime'] ?? '',
      'cefrFocus': _jlptToCefr(source['jlptFocus'] as String?),
      'scenes': scenes,
    };
  }

  Map<String, dynamic>? _normalizeChapterLine(Map<String, dynamic> source) {
    if (source['type'] == 'vocab') return null;
    return Map<String, dynamic>.of(source);
  }

  String _jlptToCefr(String? focus) {
    return switch (focus) {
      'N5' => 'A1',
      'N5-N4' => 'A1-A2',
      'N4' => 'A2',
      'N4-N3' => 'A2-B1',
      'N3' => 'B1',
      'N3-N2' => 'B1-B2',
      'N2' => 'B2',
      'N1' => 'C1',
      _ => focus ?? 'A1',
    };
  }

  /// Lightweight catalog (id/title/subtitle/cefrFocus/...) for a topic-select
  /// screen, without loading every scene's full line list.
  Future<List<Map<String, dynamic>>> loadCatalog(
    ContentCategory category,
  ) async {
    if (category == ContentCategory.lesson) {
      return <Map<String, dynamic>>[
        for (final lesson in sentenceLessons) lesson.toCatalogEntry(),
      ];
    }

    if (category == ContentCategory.vocabLesson) {
      return <Map<String, dynamic>>[
        for (final lesson in vocabularyLessons) lesson.toCatalogEntry(),
      ];
    }

    final stories = await Future.wait(
      _chapterFactories.keys.map(
        (id) => loadStory(ContentCategory.chapter, id),
      ),
    );
    return <Map<String, dynamic>>[
      for (final story in stories)
        <String, dynamic>{
          'id': story.id,
          'title': story.title,
          'subtitle': story.subtitle,
          'description': story.description,
          'estimatedTime': story.estimatedTime,
          'cefrFocus': story.cefrFocus,
        },
    ];
  }

  /// The next topic id after [currentId] in [category]'s catalog order, or
  /// `null` if [currentId] is last (or wasn't found at all).
  Future<String?> nextIdInCatalog(
    ContentCategory category,
    String currentId,
  ) async {
    final catalog = await loadCatalog(category);
    final order = catalog.map((e) => e['id'] as String).toList();
    final index = order.indexOf(currentId);
    if (index == -1 || index + 1 >= order.length) return null;
    return order[index + 1];
  }

  Future<List<VocabWord>> loadVocabulary() async {
    if (_vocabCache != null) return _vocabCache!;

    final files = [
      'assets/vocabulary/beginner_1.json',
      'assets/vocabulary/intermediate_1.json',
      'assets/vocabulary/advanced_1.json',
    ];

    final words = <VocabWord>[];
    for (final path in files) {
      final raw = await rootBundle.loadString(path);
      final list = jsonDecode(raw) as List<dynamic>;
      words.addAll(
        list.map((e) => VocabWord.fromJson(e as Map<String, dynamic>)),
      );
    }
    _vocabCache = words;
    return words;
  }
}
