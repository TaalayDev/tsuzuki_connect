import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'glass_panel.dart';

const double kAdaptiveModalWideBreakpoint = 700;
const double kAdaptiveModalMaxHeightFactor = 0.88;

const Color _kBarrierTint = Color(0x733A2E4D);

Future<T?> showAdaptiveModal<T>({required BuildContext context, required WidgetBuilder builder}) {
  final size = MediaQuery.sizeOf(context);
  final isWide = size.width >= kAdaptiveModalWideBreakpoint;
  if (!isWide) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (sheetContext) {
        final media = MediaQuery.of(sheetContext);
        final availableHeight = media.size.height - media.viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + media.viewInsets.bottom),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _AdaptiveModalSurface(
              width: media.size.width - 16,
              maxHeight: availableHeight * kAdaptiveModalMaxHeightFactor,
              child: builder(sheetContext),
            ),
          ),
        );
      },
    );
  }

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, _, _) {
      final media = MediaQuery.of(ctx);
      final card = Center(
        child: _AdaptiveModalSurface(
          width: 560,
          maxHeight: media.size.height * kAdaptiveModalMaxHeightFactor,
          child: builder(ctx),
        ),
      );

      return GestureDetector(
        onTap: () => Navigator.of(ctx).maybePop(),
        child: GestureDetector(onTap: () {}, child: card),
      );
    },
    transitionBuilder: (ctx, animation, _, child) {
      final t = Curves.easeOut.transform(animation.value);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6 * t, sigmaY: 6 * t),
        child: Container(
          color: Color.lerp(Colors.transparent, _kBarrierTint, t),
          child: isWide
              ? FadeTransition(opacity: animation, child: child)
              : SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(animation),
                  child: child,
                ),
        ),
      );
    },
  );
}

class _AdaptiveModalSurface extends StatelessWidget {
  const _AdaptiveModalSurface({required this.width, required this.maxHeight, required this.child});

  final double width;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, maxHeight: maxHeight),
      child: SizedBox(
        width: width,
        child: GlassPanel(
          borderRadius: AppRadii.dialogueBox,
          blurSigma: AppBlur.dialogueBox,
          shadows: AppShadows.dialogueBox,
          padding: EdgeInsets.zero,
          child: Material(color: Colors.transparent, child: child),
        ),
      ),
    );
  }
}

class ModalScaffold extends StatelessWidget {
  const ModalScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.brownDark.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 18, 48, 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.englishFont(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownDark,
                ).copyWith(decoration: TextDecoration.none),
              ),
            ),
            Flexible(fit: FlexFit.loose, child: child),
          ],
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: AppColors.glassBg,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).maybePop(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, size: 18, color: AppColors.brownDark),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
