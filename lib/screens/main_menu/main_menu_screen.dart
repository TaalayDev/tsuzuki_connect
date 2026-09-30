import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/access_policy.dart';
import '../../services/audio_service.dart';
import '../../services/content_service.dart';
import '../../services/i18n_service.dart';
import '../../state/i18n_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/background_video.dart';
import '../../widgets/glass_panel.dart';
import '../character_creation/character_creation_screen.dart';
import '../credits/credits_screen.dart';
import '../dialogue/dialogue_screen.dart';
import '../paywall/paywall_screen.dart';
import '../settings/settings_screen.dart';
import '../topic_select/topic_select_screen.dart';
import '../vocab_log/vocab_log_screen.dart';

enum _MenuButtonVariant { glass, primary, premium }

const double _kMenuWideBreakpoint = 980;

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  bool _soundOn = true;

  @override
  void reassemble() {
    super.reassemble();
    unawaited(ref.read(audioServiceProvider).ensureMusicPlaying());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(audioServiceProvider).playMenuMusic(fadeInSeconds: 1.5);
    });
  }

  void _toggleSound() {
    final muted = !ref.read(audioServiceProvider).isMuted;
    ref.read(audioServiceProvider).setMuted(muted);
    setState(() => _soundOn = !muted);
  }

  void _openTopicSelect(BuildContext context, ContentCategory category) {
    showAdaptiveModal(
      context: context,
      builder: (_) => TopicSelectScreen(category: category),
    );
  }

  void _pushStory(BuildContext context, ContentCategory category, String storyId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: "dialogue"),
        builder: (_) => DialogueScreen(category: category, storyId: storyId),
      ),
    );
  }

  Future<bool> _ensureStory0Complete(BuildContext context, WidgetRef ref) async {
    if (ref.read(progressProvider).completedStories.isNotEmpty) return false;

    if (!ref.read(settingsProvider).profileInitialized) {
      final completed = await showAdaptiveModal<bool>(
        context: context,
        builder: (_) => const CharacterCreationScreen(),
      );

      if (completed != true || !context.mounted) return true;
    }

    if (!context.mounted) return true;
    _pushStory(context, ContentCategory.chapter, 'story0');
    return true;
  }

  Future<void> _onStoryTap(BuildContext context, WidgetRef ref) async {
    ref.read(progressProvider.notifier).setPendingOnboardingTrack(null);
    if (await _ensureStory0Complete(context, ref)) return;
    if (!context.mounted) return;
    _openTopicSelect(context, ContentCategory.chapter);
  }

  Future<void> _onSentencesTap(BuildContext context, WidgetRef ref) async {
    if (await _ensureStory0Complete(context, ref)) {
      ref.read(progressProvider.notifier).setPendingOnboardingTrack('lesson');
      return;
    }

    if (!ref.read(progressProvider).lessonModeStarted) {
      ref.read(progressProvider.notifier).markLessonModeStarted();
      final level = ref.read(settingsProvider).playerLevel;
      if (!context.mounted) return;
      _pushStory(context, ContentCategory.lesson, AccessPolicy.firstLessonIdForLevel(level));
      return;
    }
    if (!context.mounted) return;
    _openTopicSelect(context, ContentCategory.lesson);
  }

  Future<void> _onVocabTap(BuildContext context, WidgetRef ref) async {
    if (await _ensureStory0Complete(context, ref)) {
      ref.read(progressProvider.notifier).setPendingOnboardingTrack('vocab-lesson');
      return;
    }
    if (!ref.read(progressProvider).vocabModeStarted) {
      ref.read(progressProvider.notifier).markVocabModeStarted();
      final level = ref.read(settingsProvider).playerLevel;
      if (!context.mounted) return;
      _pushStory(context, ContentCategory.vocabLesson, AccessPolicy.firstVocabLessonIdForLevel(level));
      return;
    }
    if (!context.mounted) return;
    _openTopicSelect(context, ContentCategory.vocabLesson);
  }

  bool get isMobile {
    return !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
  }

  bool get isLandscape {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final i18n = ref.watch(i18nProvider);
    ref.watch(settingsProvider); // rebuild when language changes (see settings_provider.dart)

    return Container(
      color: const Color(0xFF2A2118),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundVideoLoop(backgroundId: 'menu_background'),
          const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.menuOverlayGradient)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= _kMenuWideBreakpoint;
                final buttons = _buildButtons(context, i18n, progress.isPremium, isWide);

                if (isMobile && !isLandscape) {
                  return _NarrowMenuLayout(buttons: buttons);
                }

                if (isWide) {
                  return _WideMenuLayout(i18n: i18n, buttons: buttons);
                }

                return _NarrowMenuLayout(buttons: buttons);
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GlassButton(
                  color: AppColors.menuGlassBg,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: _toggleSound,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_soundOn ? Icons.volume_up : Icons.volume_off, size: 16, color: AppColors.cream),
                      const SizedBox(width: 8),
                      Text(
                        i18n.t(_soundOn ? 'menu.sound_on' : 'menu.sound_off'),
                        style: AppTheme.englishFont(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.cream),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context, I18nService i18n, bool isPremium, bool isWide) {
    final orientation = MediaQuery.of(context).orientation;
    return [
      _MenuButton(label: i18n.t('menu.vocab_select'), icon: Icons.spellcheck, onTap: () => _onVocabTap(context, ref)),
      _MenuButton(
        label: i18n.t('menu.lesson_select'),
        icon: Icons.chat_bubble_outline,
        onTap: () => _onSentencesTap(context, ref),
      ),
      _MenuButton(
        label: i18n.t('menu.story'),
        icon: Icons.menu_book_outlined,
        variant: _MenuButtonVariant.primary,
        onTap: () => _onStoryTap(context, ref),
      ),
      _MenuButton(
        label: i18n.t('menu.vocab_log'),
        icon: Icons.book_outlined,
        onTap: () => showAdaptiveModal(context: context, builder: (_) => const VocabLogScreen()),
      ),
      if (!isPremium) ...[
        _MenuButton(
          label: i18n.t('menu.premium'),
          icon: Icons.workspace_premium,
          variant: _MenuButtonVariant.premium,
          onTap: () => showAdaptiveModal(context: context, builder: (_) => const PaywallScreen()),
        ),
        const SizedBox(),
      ],
      if (isWide || orientation == Orientation.portrait)
        Row(
          children: [
            Expanded(
              child: _MenuButton(
                label: i18n.t('menu.settings'),
                icon: Icons.settings_outlined,
                onTap: () => showAdaptiveModal(context: context, builder: (_) => const SettingsScreen()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MenuButton(
                label: i18n.t('menu.credits'),
                icon: Icons.info_outline,
                onTap: () => showAdaptiveModal(context: context, builder: (_) => const CreditsScreen()),
              ),
            ),
          ],
        )
      else if (!isWide && orientation == Orientation.landscape) ...[
        _MenuButton(
          label: i18n.t('menu.settings'),
          icon: Icons.settings_outlined,
          onTap: () => showAdaptiveModal(context: context, builder: (_) => const SettingsScreen()),
        ),
        _MenuButton(
          label: i18n.t('menu.credits'),
          icon: Icons.info_outline,
          onTap: () => showAdaptiveModal(context: context, builder: (_) => const CreditsScreen()),
        ),
      ],
    ];
  }
}

class _WideMenuLayout extends StatelessWidget {
  const _WideMenuLayout({required this.i18n, required this.buttons});

  final I18nService i18n;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buttons,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // .menu-right: title block over the character showcase.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(56, 72, 72, 0),
                    child: _TitleBlock(i18n: i18n, alignCenter: false),
                  ),
                  // const Expanded(child: _CharacterShowcase()),
                ],
              ),
            ),
          ],
        ),
        Positioned(left: 80, bottom: 28, child: _VersionText(i18n: i18n)),
      ],
    );
  }
}

class _VersionText extends StatefulWidget {
  const _VersionText({required this.i18n});

  final I18nService i18n;

  @override
  State<_VersionText> createState() => _VersionTextState();
}

class _VersionTextState extends State<_VersionText> {
  String _versionText = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _versionText = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.i18n.t('menu.version').replaceAll('[version]', _versionText),
      style: TextStyle(fontSize: 12, color: AppColors.cream.withValues(alpha: 0.5), decoration: TextDecoration.none),
    );
  }
}

class _NarrowMenuLayout extends StatelessWidget {
  const _NarrowMenuLayout({required this.buttons});

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(builder: (context, ref, _) => _TitleBlock(i18n: ref.watch(i18nProvider), alignCenter: true)),
                  const SizedBox(height: 24),
                  if (orientation == Orientation.portrait)
                    ...buttons
                  else
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      mainAxisExtent: 60,
                      physics: const NeverScrollableScrollPhysics(),
                      children: buttons,
                    ),
                  const SizedBox(height: 16),
                  Consumer(builder: (context, ref, _) => _VersionText(i18n: ref.watch(i18nProvider))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.menu-title-block` — game title, subtitle with the gradient divider
/// bar, and tagline.
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.i18n, required this.alignCenter});

  final I18nService i18n;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    final crossAxis = alignCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = alignCenter ? TextAlign.center : TextAlign.left;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(
          'CONNECT ENGLISH',
          textAlign: textAlign,
          style: AppTheme.englishFont(
            fontSize: alignCenter ? 32 : 52,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
          ).copyWith(decoration: TextDecoration.none, letterSpacing: 0.3, height: 1.08),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(colors: [AppColors.orange, AppColors.purpleLight, AppColors.green]),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              i18n.t('menu.subtitle'),
              style: const TextStyle(
                fontSize: 16,
                letterSpacing: 0.06,
                color: Color(0xFFD9B99C),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            i18n.t('menu.tagline'),
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppColors.cream.withValues(alpha: 0.78),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// `.menu-showcase` — Alex/Natasha/Ji-woo/Li Wei lined up, bottom-aligned,
/// overlapping slightly (CSS: `flex: 5/5/4/4` slot widths with a `-4%`
/// negative margin between them). Ported with the same relative widths and
/// overlap, computed against the available width via `LayoutBuilder` since
/// Flutter has no percentage-margin equivalent to lean on directly.
class _CharacterShowcase extends StatelessWidget {
  const _CharacterShowcase();

  static const _slots = [
    (asset: 'assets/characters/tanaka_neutral.png', flex: 5),
    (asset: 'assets/characters/mei_neutral.png', flex: 5),
    (asset: 'assets/characters/ken_neutral.png', flex: 5),
    (asset: 'assets/characters/yuki_neutral.png', flex: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final bottomOffset = height * 0.25;

        return ClipRect(
          child: Row(
            children: [
              for (var i = 0; i < _slots.length; i++)
                Expanded(
                  child: Transform.translate(
                    offset: Offset(i == 0 ? 0 : -width * 0.04, bottomOffset),
                    child: Image.asset(_slots[i].asset, fit: BoxFit.fitHeight, height: height),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.variant = _MenuButtonVariant.glass,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final _MenuButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTheme.englishFont(
      fontSize: variant == _MenuButtonVariant.glass ? 16 : 17,
      fontWeight: variant == _MenuButtonVariant.glass ? FontWeight.w600 : FontWeight.w700,
      color: switch (variant) {
        _MenuButtonVariant.glass => AppColors.cream,
        _MenuButtonVariant.primary => AppColors.primaryButtonText,
        _MenuButtonVariant.premium => AppColors.premiumButtonText,
      },
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: labelStyle.color),
        const SizedBox(width: 14),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: labelStyle),
          ),
        ),
      ],
    );

    final padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 24);

    final button = switch (variant) {
      _MenuButtonVariant.glass => GlassButton(
        onTap: onTap,
        padding: padding,
        color: AppColors.menuGlassBg,
        child: content,
      ),
      _MenuButtonVariant.primary => GradientButton(
        onTap: onTap,
        gradient: AppColors.primaryButtonGradient,
        shadows: AppShadows.primaryButton,
        padding: padding,
        child: content,
      ),
      _MenuButtonVariant.premium => GradientButton(
        onTap: onTap,
        gradient: AppColors.premiumButtonGradient,
        shadows: AppShadows.premiumButton,
        padding: padding,
        child: content,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(width: double.infinity, child: button),
    );
  }
}
