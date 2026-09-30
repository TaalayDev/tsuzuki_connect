import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/story.dart';
import '../models/vocab_word.dart';
import '../novel/stories/stories.dart';
import '../novel/vocabulary_lessons/vocabulary_lessons.dart';

/// Which registry a story/lesson id belongs to — mirrors the three separate
/// content registries in the JS project. Chapters now come from Dart sources;
/// the two lesson categories retain their separate compiled registries.
enum ContentCategory { lesson, vocabLesson, chapter }

extension on ContentCategory {
  String get folder => switch (this) {
    ContentCategory.lesson => 'lessons',
    ContentCategory.vocabLesson => 'vocab-lessons',
    ContentCategory.chapter => 'chapters',
  };
}

/// Loads chapters directly from the Dart builders in `lib/novel/stories/`.
/// Sentence and vocabulary lessons still use their compiled JSON registries
/// until those sources are ported as well. Level-based vocabulary dictionaries
/// are loaded from `assets/vocabulary/`.
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

  /// [id] is the topic id from the matching `_index.json` catalog (e.g.
  /// `talking_about_your_job_or_studies` for a lesson, `story0` for a
  /// chapter — note chapter filenames already include the `story` prefix,
  /// unlike the bare numeric `id` field inside the JSON itself).
  Future<Story> loadStory(ContentCategory category, String id) async {
    final cacheKey = '${category.name}:$id';
    final cached = _storyCache[cacheKey];
    if (cached != null) return cached;

    final story = switch (category) {
      ContentCategory.chapter => _loadChapter(id),
      ContentCategory.vocabLesson => _loadVocabularyLesson(id),
      ContentCategory.lesson => await _loadAssetStory(category, id),
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

  Future<Story> _loadAssetStory(ContentCategory category, String id) async {
    final raw = await rootBundle.loadString(
      'assets/data/stories/${category.folder}/$id.json',
    );
    return Story.fromJson(jsonDecode(raw) as Map<String, dynamic>);
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
    if (category == ContentCategory.vocabLesson) {
      return <Map<String, dynamic>>[
        for (final lesson in vocabularyLessons) lesson.toCatalogEntry(),
      ];
    }

    if (category == ContentCategory.chapter) {
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

    final raw = await rootBundle.loadString(
      'assets/data/stories/${category.folder}/_index.json',
    );
    return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }

  /// `SceneManager.getNextInOrder()` (lessons/vocab-lessons) and
  /// `getNextStoryId()` (chapters) — the next topic id after [currentId] in
  /// [category]'s own `_index.json` registry order, or `null` if
  /// [currentId] is last (or wasn't found at all). Chapters' `_index.json`
  /// is already numeric `story0..story20` order, so one implementation
  /// covers all three registries instead of porting `getNextStoryId()`'s
  /// separate `story{N+1}` regex-increment approach.
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
