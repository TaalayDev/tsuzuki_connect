import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.color = AppColors.glassBgStrong,
    this.borderRadius = AppRadii.card,
    this.blurSigma = AppBlur.button,
    this.border = true,
    this.shadows = AppShadows.glass,
    this.padding,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final double blurSigma;
  final bool border;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: radius,
              border: border ? Border.all(color: AppColors.glassBorder) : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Same frosted-glass treatment as [GlassPanel], but tappable — for menu
/// buttons and list cards where the whole panel needs a ripple + onTap.
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color = AppColors.glassBgStrong,
    this.borderRadius = AppRadii.pill,
    this.blurSigma = AppBlur.button,
    this.shadows = AppShadows.glass,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double borderRadius;
  final double blurSigma;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Material(
            color: color,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A solid (non-blurred) gradient button for the primary/premium CTAs —
/// `.menu-btn-primary`/`.menu-btn-premium` are opaque gradients, not glass,
/// so they don't need `BackdropFilter`.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.gradient,
    this.borderRadius = AppRadii.pill,
    this.shadows = AppShadows.primaryButton,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Gradient gradient;
  final double borderRadius;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: radius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
