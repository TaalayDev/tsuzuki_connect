import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Product ID — must match exactly what is registered in App Store Connect / Google Play.
const String kUnlockAllStoriesProductId = 'tsuzuki_connect_unlock_all';
const String kPremiumPrefKey = 'is_premium';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  ProductDetails? _productDetails;
  String? get localizedPrice => _productDetails?.price;
  bool _storeAvailable = false;
  bool _loading = false;
  bool get isLoading => _loading;

  final _statusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStream => _statusController.stream;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    // Restore persisted premium flag
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(kPremiumPrefKey) ?? false;

    // Skip store setup on platforms that don't support IAP (e.g. desktop)
    if (!_isSupportedPlatform) {
      debugPrint('[IAP] Platform not supported for in-app purchases');
      return;
    }

    _storeAvailable = await InAppPurchase.instance.isAvailable();
    if (!_storeAvailable) {
      debugPrint('[IAP] Store not available');
      return;
    }

    // Listen for purchase updates as early as possible
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _purchaseSubscription?.cancel(),
      onError: (e) => debugPrint('[IAP] Purchase stream error: $e'),
    );

    // Load product metadata in background
    _loadProductDetails();
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _statusController.close();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<bool> buyUnlockAll() async {
    if (_isPremium) return true;
    if (!_storeAvailable) {
      debugPrint('[IAP] Store not available');
      return false;
    }
    if (_loading) return false;

    if (_productDetails == null) {
      await _loadProductDetails();
    }

    if (_productDetails == null) {
      debugPrint('[IAP] Product not found: $kUnlockAllStoriesProductId');
      return false;
    }

    _loading = true;
    final purchaseParam = PurchaseParam(productDetails: _productDetails!);
    try {
      // Non-consumable one-time purchase
      return await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      debugPrint('[IAP] Buy error: $e');
      _loading = false;
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!_storeAvailable) return;
    await InAppPurchase.instance.restorePurchases();
  }

  Future<String?> fetchLocalizedPrice() async {
    if (!_isSupportedPlatform) return null;

    if (!_storeAvailable) {
      _storeAvailable = await InAppPurchase.instance.isAvailable();
      if (!_storeAvailable) {
        debugPrint('[IAP] Store not available');
        return null;
      }
    }

    if (_productDetails == null) {
      await _loadProductDetails();
    }

    return _productDetails?.price;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get _isSupportedPlatform =>
      Platform.isIOS || Platform.isAndroid || Platform.isMacOS;

  Future<void> _loadProductDetails() async {
    final response = await InAppPurchase.instance.queryProductDetails({
      kUnlockAllStoriesProductId,
    });
    if (response.productDetails.isNotEmpty) {
      _productDetails = response.productDetails.first;
      debugPrint(
        '[IAP] Product loaded: ${_productDetails!.title} — ${_productDetails!.price}',
      );
    } else {
      debugPrint(
        '[IAP] Product not found. Not-found IDs: ${response.notFoundIDs}',
      );
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> updates) async {
    for (final purchase in updates) {
      if (purchase.productID != kUnlockAllStoriesProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          debugPrint('[IAP] Purchase pending…');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliverPurchase(purchase);
          break;

        case PurchaseStatus.error:
          debugPrint('[IAP] Purchase error: ${purchase.error}');
          _loading = false;
          break;

        case PurchaseStatus.canceled:
          debugPrint('[IAP] Purchase canceled');
          _loading = false;
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  Future<void> _deliverPurchase(PurchaseDetails purchase) async {
    debugPrint('[IAP] Delivering purchase: ${purchase.productID}');
    _isPremium = true;
    _loading = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPremiumPrefKey, true);
    _statusController.add(true);
  }
}
