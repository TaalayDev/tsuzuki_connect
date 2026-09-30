/// Topic unlock rules, ported from `js/engine/Game.js`.
///
/// Note: sequential "finish the previous topic first" locking exists in the
/// JS source (`isLessonAccessible`/`isVocabLessonAccessible`) but is
/// dead code there — each function has a `return true;` in front of it
/// with a `// Enabled for testing; remove to enforce lesson order` comment,
/// so in the shipped app **every topic is unlocked regardless of
/// progress**, and the only real gate is the paid tier (Elementary+ for
/// Sentences, Intermediate+ for Vocabulary, any B-level CEFR chapter for
/// Story) behind the Premium IAP. This mirrors that actual behavior, not
/// the disabled stricter rule — if the JS project re-enables it, port the
/// change here too.
///
/// Chapter unlocking (`js/systems/StoryAccess.js`) is separately gated by
/// `UNLOCK_ALL_STORIES`, currently `true` — all chapters open regardless of
/// story number. Mirrored the same way: no story-number gate here.
class AccessPolicy {
  AccessPolicy._();

  static const paidLessonTierStart = 'talking_about_your_weekend';
  static const paidVocabLessonTierStart = 'vocab_lesson_11';

  /// [order] is the topic id list in unlock order, from the category's
  /// `_index.json` catalog.
  static bool isLessonPaidTier(String lessonId, List<String> order) {
    final index = order.indexOf(lessonId);
    final boundary = order.indexOf(paidLessonTierStart);
    return index != -1 && boundary != -1 && index >= boundary;
  }

  static bool isVocabLessonPaidTier(String lessonId, List<String> order) {
    final index = order.indexOf(lessonId);
    final boundary = order.indexOf(paidVocabLessonTierStart);
    return index != -1 && boundary != -1 && index >= boundary;
  }

  /// Chapters don't use an id-order boundary — any chapter whose CEFR
  /// focus includes a B-level (B1/B2) is paid tier.
  static bool isStoryPaidTier(String? cefrFocus) {
    return cefrFocus != null && cefrFocus.contains('B');
  }

  static bool isAccessible({
    required bool isPaidTier,
    required bool hasPremium,
  }) {
    return !isPaidTier || hasPremium;
  }

  /// `Game.firstLessonIdForLevel()` — Sentences mode's Beginner/Elementary/
  /// Intermediate tiers line up exactly with the three English levels
  /// offered at character creation (`beginner`/`some`/`intermediate`).
  static String firstLessonIdForLevel(String level) {
    if (level == 'some') {
      return 'talking_about_your_weekend'; // Elementary (A2) tier start
    }
    if (level == 'intermediate') {
      return 'debating_a_controversial_topic_in_class'; // Intermediate (B1) tier start
    }
    return 'meeting_someone_new'; // Beginner (A1) tier start — default
  }

  /// `Game.firstVocabLessonIdForLevel()` — Vocabulary mode only has
  /// Beginner/Intermediate/Advanced tiers (no separate "Elementary" step),
  /// so "Some Knowledge (A2)" and "Intermediate (B1)" both land on its
  /// Intermediate tier.
  static String firstVocabLessonIdForLevel(String level) {
    // Only Lesson 1 exists in the new classroom curriculum for now. Once
    // later tiers are authored this can route to their first lesson while
    // retaining Lesson 1 as the onboarding entry point for new players.
    return 'vocab_lesson_01';
  }
}
