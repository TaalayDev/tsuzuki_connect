import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/access_policy.dart';
import '../../services/content_service.dart';
import '../../state/i18n_provider.dart';
import '../../state/settings_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/scene_player_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/game_notification.dart';
import '../../widgets/glass_panel.dart';
import '../character_creation/character_creation_screen.dart';
import '../dialogue/dialogue_screen.dart';
import '../paywall/paywall_screen.dart';

/// Port of `UIManager.showChapterSelect()` / `showLessonSelect()` /
/// `showVocabSelect()` — all three render the same card layout from a
/// different topic registry, so this is one generic screen parameterized
/// by [category].
class TopicSelectScreen extends ConsumerStatefulWidget {
  const TopicSelectScreen({super.key, required this.category});

  final ContentCategory category;

  @override
  ConsumerState<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends ConsumerState<TopicSelectScreen> {
  late Future<List<Map<String, dynamic>>> _catalogFuture;

  @override
  void initState() {
    super.initState();
    _catalogFuture = ref
        .read(contentServiceProvider)
        .loadCatalog(widget.category);
  }

  bool _isPaidTier(String id, List<String> order, Map<String, dynamic> entry) {
    switch (widget.category) {
      case ContentCategory.lesson:
        return AccessPolicy.isLessonPaidTier(id, order);
      case ContentCategory.vocabLesson:
        return AccessPolicy.isVocabLessonPaidTier(id, order);
      case ContentCategory.chapter:
        return AccessPolicy.isStoryPaidTier(entry['cefrFocus'] as String?);
    }
  }

  String _titleKey() {
    switch (widget.category) {
      case ContentCategory.lesson:
        return 'runtime.lesson_select.title';
      case ContentCategory.vocabLesson:
        return 'runtime.vocab_select.title';
      case ContentCategory.chapter:
        return 'runtime.chapter_select.title';
    }
  }

  Set<String> _completedSet(ProgressState progress) {
    switch (widget.category) {
      case ContentCategory.lesson:
        return progress.completedLessons;
      case ContentCategory.vocabLesson:
        return progress.completedVocabLessons;
      case ContentCategory.chapter:
        return progress.completedStories;
    }
  }

  /// `Game.startChapter()`/`startLesson()`/`startVocabLesson()`'s
  /// no-profile-yet gate — stash `pendingDestination`, show character
  /// creation, and only proceed once it submits. If the player dismisses
  /// it, they stay on the topic list.
  Future<void> _openTopic(
    BuildContext context,
    ContentCategory category,
    String id,
  ) async {
    if (!ref.read(settingsProvider).profileInitialized) {
      final submitted = await showAdaptiveModal<bool>(
        context: context,
        builder: (_) => const CharacterCreationScreen(),
      );
      if (submitted != true || !context.mounted) return;
    }
    // This screen is shown as a modal (bottom sheet or dialog, see
    // showAdaptiveModal) over the main menu — close it before pushing the
    // full-screen gameplay route so the stack ends up main menu →
    // dialogue, not main menu → modal → dialogue.
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: "dialogue"),
        builder: (_) => DialogueScreen(category: category, storyId: id),
      ),
    );
  }

  void _openPremiumOffer(BuildContext context) {
    showAdaptiveModal<void>(
      context: context,
      builder: (_) => const PaywallScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = ref.watch(i18nProvider);
    ref.watch(
      settingsProvider,
    ); // rebuild when language changes (see settings_provider.dart)
    final progress = ref.watch(progressProvider);
    final completed = _completedSet(progress);

    return ModalScaffold(
      title: i18n.t(_titleKey()),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _catalogFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final catalog = snapshot.data!;
          final order = catalog.map((e) => e['id'] as String).toList();

          return ListView.separated(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(16),
            itemCount: catalog.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = catalog[index];
              final id = entry['id'] as String;
              final isPaidTier = _isPaidTier(id, order, entry);
              final unlocked = AccessPolicy.isAccessible(
                isPaidTier: isPaidTier,
                hasPremium: progress.isPremium,
              );
              final isDone = completed.contains(id);

              return _TopicCard(
                number: index + 1,
                title: i18n.t(entry['title'] as String? ?? ''),
                subtitle: i18n.t(entry['subtitle'] as String? ?? ''),
                cefrFocus: entry['cefrFocus'] as String?,
                estimatedTime: entry['estimatedTime'] as String?,
                unlocked: unlocked,
                isPaidTier: isPaidTier,
                isDone: isDone,
                onTap: unlocked
                    ? () => _openTopic(context, widget.category, id)
                    : isPaidTier
                    ? () => _openPremiumOffer(context)
                    : () => showGameNotification(
                        context,
                        message: i18n.t('runtime.lesson_select.complete_first'),
                        type: GameNotificationType.warning,
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.cefrFocus,
    required this.estimatedTime,
    required this.unlocked,
    required this.isPaidTier,
    required this.isDone,
    required this.onTap,
  });

  final int number;
  final String title;
  final String subtitle;
  final String? cefrFocus;
  final String? estimatedTime;
  final bool unlocked;
  final bool isPaidTier;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.6,
      child: GlassButton(
        borderRadius: AppRadii.card,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isDone ? AppColors.green : AppColors.orangeLight,
              child: Text(
                isDone ? '✓' : '$number',
                style: const TextStyle(
                  color: AppColors.brownDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  if (cefrFocus != null || estimatedTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        [
                          if (cefrFocus != null) 'CEFR: $cefrFocus',
                          if (estimatedTime != null) estimatedTime,
                        ].join(' • '),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!unlocked)
              Icon(
                isPaidTier
                    ? Icons.workspace_premium_outlined
                    : Icons.lock_outline,
                color: AppColors.brownDark,
              )
            else
              const Icon(Icons.chevron_right, color: AppColors.brownDark),
          ],
        ),
      ),
    );
  }
}
