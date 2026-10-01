import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/analytics_provider.dart';
import '../../state/i18n_provider.dart';
import '../../state/iap_provider.dart';
import '../../state/progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/adaptive_modal.dart';
import '../../widgets/game_notification.dart';
import '../../widgets/glass_panel.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String? _price;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).logEvent('paywall_view');
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final iap = ref.read(iapServiceProvider);
    if (!await iap.isAvailable) return;
    final response = await iap.getProducts();
    if (!mounted || response.productDetails.isEmpty) return;
    setState(() => _price = response.productDetails.first.price);
  }

  void _notify(
    String message, {
    GameNotificationType type = GameNotificationType.info,
  }) {
    if (!mounted) return;
    showGameNotification(context, message: message, type: type);
  }

  Future<void> _onUnlocked() async {
    ref.read(progressProvider.notifier).setPremium(true);
    ref.read(analyticsProvider).logEvent('premium_unlocked');
    if (!mounted) return;
    _notify(
      ref.read(i18nProvider).t('runtime.iap.purchase_success'),
      type: GameNotificationType.success,
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _purchase() async {
    final i18n = ref.read(i18nProvider);
    final iap = ref.read(iapServiceProvider);
    if (!await iap.isAvailable) {
      _notify(
        i18n.t('runtime.iap.web_unavailable'),
        type: GameNotificationType.warning,
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final response = await iap.getProducts();
      final product = response.productDetails.isEmpty
          ? null
          : response.productDetails.first;
      if (product == null) {
        _notify(
          i18n.t('runtime.iap.purchase_failed'),
          type: GameNotificationType.error,
        );
        return;
      }

      ref.read(analyticsProvider).logEvent('purchase_start');
      await iap.buyPremium(product);
    } catch (_) {
      _notify(
        i18n.t('runtime.iap.purchase_failed'),
        type: GameNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final i18n = ref.read(i18nProvider);
    final iap = ref.read(iapServiceProvider);
    if (!await iap.isAvailable) {
      _notify(
        i18n.t('runtime.iap.web_unavailable'),
        type: GameNotificationType.warning,
      );
      return;
    }
    setState(() => _busy = true);
    await iap.restorePurchases();
    if (mounted) setState(() => _busy = false);
    // `in_app_purchase`'s `restorePurchases()` replays past purchases
    // through the same stream `_onUnlocked` listens to, same as a fresh
    // purchase — there's no direct "nothing to restore" signal from the
    // plugin, so (like the JS version's own `IAP.restore()` timeout path)
    // silence just means nothing was found.
  }

  @override
  Widget build(BuildContext context) {
    final i18n = ref.watch(i18nProvider);
    final iap = ref.watch(iapServiceProvider);

    return StreamBuilder<bool>(
      stream: iap.isPremiumOwned,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _onUnlocked());
        }

        return ModalScaffold(
          title: i18n.t('runtime.iap.title'),
          child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              const _PremiumHero(),
              const SizedBox(height: 14),
              Center(
                child: _OneTimeChip(
                  label: i18n.t('runtime.iap.badge_one_time'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                i18n.t('runtime.iap.headline'),
                textAlign: TextAlign.center,
                style: AppTheme.englishFont(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownDark,
                ).copyWith(decoration: TextDecoration.none, height: 1.25),
              ),
              const SizedBox(height: 8),
              Text(
                i18n.t('runtime.iap.description'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.brownDark.withValues(alpha: 0.78),
                  height: 1.45,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                decoration: BoxDecoration(
                  color: AppColors.glassBgStrong,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  children: [
                    _BenefitRow(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: AppColors.purple,
                      text: i18n.t('runtime.iap.benefit_sentences'),
                    ),
                    _BenefitRow(
                      icon: Icons.translate_rounded,
                      color: AppColors.orange,
                      text: i18n.t('runtime.iap.benefit_vocab'),
                    ),
                    _BenefitRow(
                      icon: Icons.auto_stories_outlined,
                      color: AppColors.greenDark,
                      text: i18n.t('runtime.iap.benefit_stories'),
                    ),
                    _BenefitRow(
                      icon: Icons.all_inclusive_rounded,
                      color: const Color(0xFFD8943F),
                      text: i18n.t('runtime.iap.benefit_future'),
                      highlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_price != null)
                Text(
                  _price!,
                  textAlign: TextAlign.center,
                  style: AppTheme.englishFont(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purpleDark,
                  ).copyWith(decoration: TextDecoration.none, height: 1.1),
                ),
              if (_price != null) const SizedBox(height: 4),
              Text(
                i18n.t('runtime.iap.price_caption'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.brownDark.withValues(alpha: 0.7),
                  fontSize: 13,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 14),
              GradientButton(
                onTap: _busy ? null : _purchase,
                gradient: AppColors.premiumButtonGradient,
                shadows: AppShadows.premiumButton,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.premiumButtonText,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_open_rounded,
                              size: 20,
                              color: AppColors.premiumButtonText,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              i18n.t('runtime.iap.unlock'),
                              style: AppTheme.englishFont(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.premiumButtonText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              GlassButton(
                onTap: _busy ? null : _restore,
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Center(
                  child: Text(
                    i18n.t('runtime.iap.restore'),
                    style: AppTheme.englishFont(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brownDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                i18n.t('runtime.iap.free_note'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.brownDark.withValues(alpha: 0.6),
                  fontSize: 12,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PremiumHero extends StatelessWidget {
  const _PremiumHero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 84,
        height: 84,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.premiumButtonGradient,
          boxShadow: AppShadows.premiumButton,
        ),
        child: const Icon(
          Icons.workspace_premium_rounded,
          size: 46,
          color: AppColors.premiumButtonText,
        ),
      ),
    );
  }
}

class _OneTimeChip extends StatelessWidget {
  const _OneTimeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greenDark.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTheme.englishFont(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.greenDark,
        ).copyWith(letterSpacing: 0.8, decoration: TextDecoration.none),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.color,
    required this.text,
    this.highlight = false,
  });

  final IconData icon;
  final Color color;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: highlight ? color.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.brownDark,
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            if (highlight)
              Icon(Icons.check_circle_rounded, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}
