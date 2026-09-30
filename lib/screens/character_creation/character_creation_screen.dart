import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/i18n_provider.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/game_notification.dart';
import '../../widgets/glass_panel.dart';

/// Port of `#character-creation` — shown (via [showAdaptiveModal], like the
/// rest of this port's "modal" screens) the first time the player opens a
/// Story/Sentences/Vocabulary topic without a saved profile
/// (`settings.profileInitialized`). Collects a name, an English level
/// (`beginner`/`some`/`intermediate`, matching `data-level` in the JS
/// markup), and the same three language-support toggles Settings has,
/// then writes them straight to `settingsProvider` — mirroring
/// `Game.setPlayerProfile()` — and pops `true` so the caller can proceed
/// to the topic that triggered this screen.
///
/// Pops `false`/`null` if dismissed without submitting, so the caller
/// knows not to continue into the story.
class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  ConsumerState<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState
    extends ConsumerState<CharacterCreationScreen> {
  final _nameController = TextEditingController();
  String _level = 'beginner';
  late bool _showTranslation;
  late bool _showTranscription;
  late bool _showChoiceTranslation;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _showTranslation = settings.showSubtitles;
    _showTranscription = settings.showTranscription;
    _showChoiceTranslation = settings.showChoiceTranslation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final i18n = ref.read(i18nProvider);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showGameNotification(
        context,
        message: i18n.t('runtime.name_required'),
        type: GameNotificationType.warning,
      );
      return;
    }
    ref
        .read(settingsProvider.notifier)
        .update(
          (s) => s.copyWith(
            profileInitialized: true,
            playerName: name,
            playerLevel: _level,
            showSubtitles: _showTranslation,
            showTranscription: _showTranscription,
            showChoiceTranslation: _showChoiceTranslation,
          ),
        );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = ref.watch(i18nProvider);

    return ModalScaffold(
      title: i18n.t('cc.title'),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        children: [
          _FieldLabel(i18n.t('cc.name')),
          TextField(
            controller: _nameController,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: i18n.t('cc.name_placeholder'),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.7),
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                borderSide: BorderSide(
                  color: AppColors.purple.withValues(alpha: 0.18),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                borderSide: BorderSide(
                  color: AppColors.purple.withValues(alpha: 0.18),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                borderSide: const BorderSide(color: AppColors.orange, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _FieldLabel(i18n.t('cc.level')),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.1,
            children: [
              _LevelButton(
                icon: Icons.eco_outlined,
                label: i18n.t('cc.levels.beginner'),
                selected: _level == 'beginner',
                onTap: () => setState(() => _level = 'beginner'),
              ),
              _LevelButton(
                icon: Icons.menu_book_outlined,
                label: i18n.t('cc.levels.some'),
                selected: _level == 'some',
                onTap: () => setState(() => _level = 'some'),
              ),
              _LevelButton(
                icon: Icons.forum_outlined,
                label: i18n.t('cc.levels.intermediate'),
                selected: _level == 'intermediate',
                onTap: () => setState(() => _level = 'intermediate'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _FieldLabel(i18n.t('settings.support.section')),
          _ToggleRow(
            label: i18n.t('settings.support.subtitles'),
            value: _showTranslation,
            onChanged: (v) => setState(() => _showTranslation = v),
          ),
          _ToggleRow(
            label: i18n.t('settings.support.reading'),
            value: _showTranscription,
            onChanged: (v) => setState(() => _showTranscription = v),
          ),
          _ToggleRow(
            label: i18n.t('settings.support.choice_translation'),
            value: _showChoiceTranslation,
            onChanged: (v) => setState(() => _showChoiceTranslation = v),
          ),
          const SizedBox(height: 16),
          GradientButton(
            onTap: () => _submit(context),
            gradient: AppColors.primaryButtonGradient,
            shadows: AppShadows.primaryButton,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.send,
                  size: 18,
                  color: AppColors.primaryButtonText,
                ),
                const SizedBox(width: 12),
                Text(
                  i18n.t('cc.begin'),
                  style: AppTheme.englishFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryButtonText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTheme.englishFont(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.purple,
        ).copyWith(letterSpacing: 0.5),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  const _LevelButton({
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
    return Material(
      color: selected ? null : Colors.white.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected
              ? AppColors.orange
              : AppColors.purple.withValues(alpha: 0.15),
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF0F5), Color(0xFFF3E9F7)],
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? AppColors.orange
                      : AppColors.purple.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.englishFont(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brownDark,
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.brownDark),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.orange,
          ),
        ],
      ),
    );
  }
}
