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

  void _notify(String message, {GameNotificationType type = GameNotificationType.info}) {
    if (!mounted) return;
    showGameNotification(context, message: message, type: type);
  }

  Future<void> _onUnlocked() async {
    ref.read(progressProvider.notifier).setPremium(true);
    ref.read(analyticsProvider).logEvent('premium_unlocked');
    if (!mounted) return;
    _notify(ref.read(i18nProvider).t('runtime.iap.purchase_success'), type: GameNotificationType.success);
    Navigator.of(context).maybePop();
  }

  Future<void> _purchase() async {
    final i18n = ref.read(i18nProvider);
    final iap = ref.read(iapServiceProvider);
    if (!await iap.isAvailable) {
      _notify(i18n.t('runtime.iap.web_unavailable'), type: GameNotificationType.warning);
      return;
    }
    setState(() => _busy = true);
    try {
      final response = await iap.getProducts();
      final product = response.productDetails.isEmpty ? null : response.productDetails.first;
      if (product == null) {
        _notify(i18n.t('runtime.iap.purchase_failed'), type: GameNotificationType.error);
        return;
      }

      ref.read(analyticsProvider).logEvent('purchase_start');
      await iap.buyPremium(product);
    } catch (_) {
      _notify(i18n.t('runtime.iap.purchase_failed'), type: GameNotificationType.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final i18n = ref.read(i18nProvider);
    final iap = ref.read(iapServiceProvider);
    if (!await iap.isAvailable) {
      _notify(i18n.t('runtime.iap.web_unavailable'), type: GameNotificationType.warning);
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
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            children: [
              const Icon(Icons.lock_outline, size: 40, color: AppColors.orange),
              const SizedBox(height: 12),
              Text(
                i18n.t('runtime.iap.description'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.brownDark, height: 1.5),
              ),
              if (_price != null) ...[
                const SizedBox(height: 12),
                Text(
                  _price!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
              const SizedBox(height: 20),
              GradientButton(
                onTap: _busy ? null : _purchase,
                gradient: AppColors.primaryButtonGradient,
                shadows: AppShadows.primaryButton,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: _busy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryButtonText),
                        )
                      : Text(
                          i18n.t('runtime.iap.unlock'),
                          style: AppTheme.englishFont(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryButtonText,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              GlassButton(
                onTap: _busy ? null : _restore,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    i18n.t('runtime.iap.restore'),
                    style: AppTheme.englishFont(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.brownDark),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
