import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';

/// Top UI bar containing game controls (back, skip, auto, menu)
class TopUIBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final VoidCallback onAuto;
  final VoidCallback onMenu;
  final bool isSkipping;
  final bool isAutoMode;

  const TopUIBar({
    super.key,
    required this.onBack,
    required this.onSkip,
    required this.onAuto,
    required this.onMenu,
    required this.isSkipping,
    required this.isAutoMode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            _TopUIButton(
              icon: Icons.arrow_back,
              onPressed: onBack,
              tooltip: 'Back',
            ),
            const Spacer(),
            _TopUIButton(
              icon: Icons.fast_forward,
              onPressed: onSkip,
              tooltip: 'Skip',
              isActive: isSkipping,
            ),
            _TopUIButton(
              icon: Icons.play_circle,
              onPressed: onAuto,
              tooltip: 'Auto',
              isActive: isAutoMode,
            ),
            _TopUIButton(
              icon: Icons.menu,
              onPressed: onMenu,
              tooltip: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}

class _TopUIButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool isActive;

  const _TopUIButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isActive ? context.theme.colorScheme.primary : Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      tooltip: tooltip,
    );
  }
}
