import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../core/services/settings_service.dart';
import '../../data/models/save_game_model.dart';
import '../../providers/database_provider.dart';
import '../../providers/sound_controller.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/home/recent_save_card.dart';
import '../widgets/home/feature_button.dart';
import '../widgets/home/settings_panel.dart';

import '../../providers/app_providers.dart';
import '../widgets/home/error_report_dialog.dart';
import '../widgets/home/save_games_dialog.dart';
import '../widgets/common/about_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showingSavesDialog = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowReviewDialog(context, ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildSettingsPanel(),
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(
            backgroundAsset: 'assets/images/backgrounds/menu_background.webp',
            showParticles: true,
            isDarkMode: false,
          ),

          _AppBar(onMenuTap: () {
            ref.read(soundControllerProvider.notifier).playClick();
            _scaffoldKey.currentState?.openEndDrawer();
          }),

          // Main content
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (screenHeight > 500) ...[
                        _buildLogoSection(),
                      ],
                      _buildActionButtons(),
                      if (screenHeight > 500) ...[
                        const SizedBox(height: 132),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const CharacterShowcase(showTitle: false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Hero(
        tag: 'game_logo',
        child: SizedBox(
          width: 280,
          height: 280,
          child: Center(
            child: Image.asset(
              'assets/images/ui/logo.png',
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          delay: 100.ms,
          duration: 600.ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildActionButtons() {
    final allSaveGames = ref.watch(allSaveGamesProvider);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          _MenuButton(
            icon: Feather.play,
            title: 'New Game',
            onPressed: _startNewGame,
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Continue',
            icon: Feather.save,
            onPressed: allSaveGames.when(
              data: (saves) {
                if (saves.isEmpty) {
                  return null;
                } else {
                  return _showSavesDialog;
                }
              },
              loading: () => null,
              error: (error, stack) => null,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Kotoba Log',
            icon: Feather.book,
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.push(AppConstants.routeKotobaLog);
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Culture Notes',
            icon: Feather.info,
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.push(AppConstants.routeCultureNotes);
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 12),
          _MenuButton(
            title: 'Placement Test',
            icon: Feather.award,
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              context.push(AppConstants.routePlacementTest);
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 100.ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
        ],
      ),
    );
  }

  void _showRateAppDialog() async {
    ref.read(soundControllerProvider.notifier).playClick();
    await ref.read(inAppReviewProvider).requestReview();
  }

  Future<void> checkAndShowReviewDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final reviewService = ref.read(inAppReviewProvider);
    final shouldRequest = await reviewService.shouldRequestReview();

    if (shouldRequest && context.mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          reviewService.requestReview();
        }
      });
    }
  }

  void _showReportErrorDialog() {
    ref.read(soundControllerProvider.notifier).playClick();
    ErrorReportDialog.show(context);
  }

  Widget _buildSettingsPanel() {
    return SafeArea(
      child: SettingsPanel(
        onShowAbout: _showAboutDialog,
        onReplayTutorial: _replayTutorial,
        onClose: () {
          _scaffoldKey.currentState?.closeEndDrawer();
        },
      ),
    );
  }

  void _showSavesDialog() {
    ref.read(soundControllerProvider.notifier).playClick();
    if (_showingSavesDialog) return;

    setState(() {
      _showingSavesDialog = true;
    });

    showDialog(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: SaveGamesDialog(
          onDismiss: () {
            Navigator.of(context).pop(); // Close the dialog
            setState(() {
              _showingSavesDialog = false;
            });
          },
        ),
      ),
    );
  }

  void _showAboutDialog() {
    ref.read(soundControllerProvider.notifier).playClick();

    AboutAppDialog.show(context);
  }

  void _replayTutorial() {
    ref.read(soundControllerProvider.notifier).playClick();
    SettingsService.setOnboardingCompleted(false);
    context.go('/onboarding');
  }

  void _startNewGame() {
    ref.read(soundControllerProvider.notifier).playClick();
    context.push('${AppConstants.routeGame}?chapter=chapter_1');
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 280,
      height: screenHeight > 500 ? 70 : 60,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: context.theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 4,
          side: BorderSide(
            color: context.theme.colorScheme.inversePrimary,
            width: 2,
          ),
          iconColor: context.theme.colorScheme.onSurface,
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
          begin: 0.3,
          end: 0,
          delay: 200.ms,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: onMenuTap,
          icon: Icon(
            Icons.settings,
            color: context.theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
