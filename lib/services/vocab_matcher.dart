import '../models/vocab_word.dart';

/// Ported 1:1 from `js/systems/vocabulary/matcher.js`: finds vocabulary
/// words inside dialogue text and reports non-overlapping match spans, so
/// the dialogue box can render them as tappable highlighted words (the
/// `.vocab-hl`/`.vocab-hl-target`/`.vocab-hl-known` spans in the JS
/// version) that open [showVocabPopup].
class VocabMatch {
  const VocabMatch({required this.start, required this.end, required this.word});

  final int start;
  final int end;
  final VocabWord word;
}

/// Game "level" (beginner/intermediate/advanced) -> its max CEFR, mirrors
/// `LEVEL_MAX_CEFR` in the JS matcher.
const Map<String, String> _levelMaxCefr = {
  'beginner': 'A2',
  'intermediate': 'B2',
  'advanced': 'C2',
};

const List<String> _cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

int _cefrIndex(String level) {
  final i = _cefrOrder.indexOf(level);
  return i == -1 ? _cefrOrder.length - 1 : i;
}

/// Whether [word] should be highlighted for a player at [playerLevel] —
/// only words at or below the player's level are ever highlighted.
bool isHighlightable(VocabWord word, String playerLevel) {
  final max = _levelMaxCefr[playerLevel] ?? 'A2';
  return _cefrIndex(word.cefrLevel) <= _cefrIndex(max);
}

/// Word-boundary regex for a single vocabulary word/phrase, escaping regex
/// metacharacters — same pattern as `buildWordRegex()` in the JS matcher.
RegExp _wordRegex(String word) {
  final escaped = RegExp.escape(word);
  return RegExp("(^|[^A-Za-z'])($escaped)(?![A-Za-z'])", caseSensitive: false);
}

/// Finds all vocabulary matches in [text] for a player at [playerLevel],
/// longest words first so multi-word phrases win over a single word they
/// contain, then resolves overlaps by scan position (first match wins).
List<VocabMatch> findVocabularyInText(
  String text,
  List<VocabWord> vocabulary, {
  String playerLevel = 'beginner',
}) {
  if (text.isEmpty) return const [];

  final sorted = vocabulary.toList()..sort((a, b) => b.word.length.compareTo(a.word.length));

  final raw = <VocabMatch>[];
  for (final word in sorted) {
    if (!isHighlightable(word, playerLevel)) continue;
    final regex = _wordRegex(word.word);
    for (final m in regex.allMatches(text)) {
      final prefixLen = (m.group(1) ?? '').length;
      final start = m.start + prefixLen;
      final end = start + (m.group(2) ?? '').length;
      raw.add(VocabMatch(start: start, end: end, word: word));
    }
  }

  raw.sort((a, b) {
    final byStart = a.start.compareTo(b.start);
    if (byStart != 0) return byStart;
    return (b.end - b.start).compareTo(a.end - a.start);
  });

  final result = <VocabMatch>[];
  var lastEnd = -1;
  for (final match in raw) {
    if (match.start >= lastEnd) {
      result.add(match);
      lastEnd = match.end;
    }
  }
  return result;
}
