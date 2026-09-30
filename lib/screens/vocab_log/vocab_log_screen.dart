import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/vocab_word.dart';
import '../../services/i18n_service.dart';
import '../../state/i18n_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/scene_player_provider.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/glass_panel.dart';

/// Port of the "Vocabulary Log" screen: every word the player has marked
/// learned (`progressProvider.vocabLearned`), pulled from the full word
/// list and shown with its definition, example, and translation in the
/// current UI language — plus a speak button (`TtsService`).
class VocabLogScreen extends ConsumerStatefulWidget {
  const VocabLogScreen({super.key});

  @override
  ConsumerState<VocabLogScreen> createState() => _VocabLogScreenState();
}

class _VocabLogScreenState extends ConsumerState<VocabLogScreen> {
  late Future<List<VocabWord>> _vocabFuture;
  _VocabTab _selectedTab = _VocabTab.all;
  String? _selectedDifficulty;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _vocabFuture = ref.read(contentServiceProvider).loadVocabulary();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = ref.watch(i18nProvider);
    final settings = ref.watch(settingsProvider);
    final learned = ref.watch(progressProvider).vocabLearned;
    final ttsService = ref.read(ttsServiceProvider);

    return ModalScaffold(
      title: i18n.t('menu.vocab_log'),
      child: FutureBuilder<List<VocabWord>>(
        future: _vocabFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final words = snapshot.data!
              .where((w) => learned.contains(w.id))
              .toList();

          if (words.isEmpty) {
            return _EmptyVocabLog(i18n: i18n);
          }

          final difficulties =
              words.map((word) => word.cefrLevel).toSet().toList()
                ..sort(_compareCefr);
          final categories = words.map((word) => word.category).toSet().toList()
            ..sort((a, b) => _categoryLabel(a).compareTo(_categoryLabel(b)));
          final filteredWords = switch (_selectedTab) {
            _VocabTab.all => words,
            _VocabTab.difficulty when _selectedDifficulty != null =>
              words
                  .where((word) => word.cefrLevel == _selectedDifficulty)
                  .toList(),
            _VocabTab.category when _selectedCategory != null =>
              words
                  .where((word) => word.category == _selectedCategory)
                  .toList(),
            _ => words,
          };

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _VocabTabs(
                i18n: i18n,
                selected: _selectedTab,
                onSelected: (tab) => setState(() => _selectedTab = tab),
              ),
              if (_selectedTab == _VocabTab.difficulty)
                _FilterRail(
                  allLabel: i18n.t('vocab.filter.all'),
                  options: difficulties,
                  selected: _selectedDifficulty,
                  labelFor: (value) => value,
                  onSelected: (value) {
                    setState(() => _selectedDifficulty = value);
                  },
                ),
              if (_selectedTab == _VocabTab.category)
                _FilterRail(
                  allLabel: i18n.t('vocab.filter.all'),
                  options: categories,
                  selected: _selectedCategory,
                  labelFor: _categoryLabel,
                  onSelected: (value) {
                    setState(() => _selectedCategory = value);
                  },
                ),
              Flexible(
                fit: FlexFit.loose,
                child: filteredWords.isEmpty
                    ? _NoFilterResults(i18n: i18n)
                    : ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                        itemCount: filteredWords.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final word = filteredWords[index];
                          return _VocabWordCard(
                            word: word,
                            translation: word.tr[settings.language],
                            onSpeak: () => ttsService.speak(word.word),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _VocabTab { all, difficulty, category }

int _compareCefr(String a, String b) {
  const order = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  final aIndex = order.indexOf(a.toUpperCase());
  final bIndex = order.indexOf(b.toUpperCase());
  if (aIndex == -1 || bIndex == -1) return a.compareTo(b);
  return aIndex.compareTo(bIndex);
}

String _categoryLabel(String category) {
  return category
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class _VocabTabs extends StatelessWidget {
  const _VocabTabs({
    required this.i18n,
    required this.selected,
    required this.onSelected,
  });

  final I18nService i18n;
  final _VocabTab selected;
  final ValueChanged<_VocabTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          _VocabTabButton(
            icon: Icons.auto_awesome_rounded,
            label: i18n.t('vocab.tabs.all'),
            selected: selected == _VocabTab.all,
            onTap: () => onSelected(_VocabTab.all),
          ),
          _VocabTabButton(
            icon: Icons.signal_cellular_alt_rounded,
            label: i18n.t('vocab.tabs.difficulty'),
            selected: selected == _VocabTab.difficulty,
            onTap: () => onSelected(_VocabTab.difficulty),
          ),
          _VocabTabButton(
            icon: Icons.category_outlined,
            label: i18n.t('vocab.tabs.category'),
            selected: selected == _VocabTab.category,
            onTap: () => onSelected(_VocabTab.category),
          ),
        ],
      ),
    );
  }
}

class _VocabTabButton extends StatelessWidget {
  const _VocabTabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.primaryButtonGradient : null,
              borderRadius: BorderRadius.circular(AppRadii.pill),
              boxShadow: selected ? AppShadows.primaryButton : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? AppColors.primaryButtonText
                      : AppColors.purpleDark.withValues(alpha: 0.66),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.englishFont(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryButtonText
                          : AppColors.purpleDark.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.allLabel,
    required this.options,
    required this.selected,
    required this.labelFor,
    required this.onSelected,
  });

  final String allLabel;
  final List<String> options;
  final String? selected;
  final String Function(String value) labelFor;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          _FilterPill(
            label: allLabel,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final option in options) ...[
            const SizedBox(width: 8),
            _FilterPill(
              label: labelFor(option),
              selected: selected == option,
              onTap: () => onSelected(option),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.purple.withValues(alpha: 0.14)
          : Colors.white.withValues(alpha: 0.34),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? AppColors.purple.withValues(alpha: 0.34)
              : Colors.white.withValues(alpha: 0.72),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: AppTheme.englishFont(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.purpleDark : AppColors.brownDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _VocabWordCard extends StatelessWidget {
  const _VocabWordCard({
    required this.word,
    required this.translation,
    required this.onSpeak,
  });

  final VocabWord word;
  final String? translation;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  word.word,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              if (translation != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      translation!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ),
              IconButton(
                tooltip: word.word,
                icon: const Icon(Icons.volume_up, color: AppColors.purple),
                onPressed: onSpeak,
              ),
            ],
          ),
          Text(word.definition, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(
            '"${word.example}"',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _WordMetaLabel(label: word.cefrLevel),
              _WordMetaLabel(label: word.partOfSpeech),
              _WordMetaLabel(label: _categoryLabel(word.category)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WordMetaLabel extends StatelessWidget {
  const _WordMetaLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
      ),
    );
  }
}

class _NoFilterResults extends StatelessWidget {
  const _NoFilterResults({required this.i18n});

  final I18nService i18n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.filter_alt_off_rounded,
            size: 38,
            color: AppColors.purple,
          ),
          const SizedBox(height: 12),
          Text(
            i18n.t('vocab.filter.empty'),
            textAlign: TextAlign.center,
            style: AppTheme.japaneseFont(
              fontSize: 14,
              color: AppColors.brownDark.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyVocabLog extends StatelessWidget {
  const _EmptyVocabLog({required this.i18n});

  final I18nService i18n;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 600;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: compact ? 16 : 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: GlassPanel(
            borderRadius: 28,
            color: Colors.white.withValues(alpha: 0.48),
            padding: EdgeInsets.fromLTRB(
              28,
              compact ? 24 : 32,
              28,
              compact ? 24 : 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: compact ? 78 : 92,
                      height: compact ? 78 : 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFD9C0), Color(0xFFE3D9F7)],
                        ),
                        boxShadow: AppShadows.primaryButton,
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: compact ? 34 : 40,
                        color: AppColors.purpleDark,
                      ),
                    ),
                    const Positioned(
                      top: -3,
                      right: -8,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 25,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 18 : 24),
                Text(
                  i18n.t('vocab_log.empty.title'),
                  textAlign: TextAlign.center,
                  style: AppTheme.englishFont(
                    fontSize: compact ? 20 : 23,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brownDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  i18n.t('vocab_log.empty.body'),
                  textAlign: TextAlign.center,
                  style: AppTheme.japaneseFont(
                    fontSize: compact ? 14 : 15,
                    color: AppColors.brownDark.withValues(alpha: 0.72),
                  ).copyWith(height: 1.5),
                ),
                SizedBox(height: compact ? 16 : 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app_rounded,
                        size: 17,
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          i18n.t('vocab_log.empty.hint'),
                          textAlign: TextAlign.center,
                          style: AppTheme.englishFont(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.purpleDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
