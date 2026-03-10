import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tsuzuki_connect/core/services/settings_service.dart';

/// Product ID — must match exactly what is registered in App Store Connect / Google Play.
const String kUnlockAllStoriesProductId = 'tsuzuki_connect_unlock_all';
const String kWindowsUnlockAllStoreId = String.fromEnvironment(
  'WINDOWS_UNLOCK_ALL_STORE_ID',
  defaultValue: kUnlockAllStoriesProductId,
);
const String kPremiumPrefKey = kDebugMode ? 'is_premium_1' : 'is_premium';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  ProductDetails? _productDetails;
  String? _windowsLocalizedPrice;
  String? get localizedPrice => Platform.isWindows ? _windowsLocalizedPrice : _productDetails?.price;
  bool _storeAvailable = false;
  bool _loading = false;
  bool get isLoading => _loading;

  final _statusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStream => _statusController.stream;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  static const MethodChannel _windowsIapChannel = MethodChannel('tsuzuki/windows_iap');

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    // Restore persisted premium flag
    _isPremium = SettingsService.getBool(kPremiumPrefKey) ?? false;
    // _statusController.add(_isPremium);

    print('isPremium: $_isPremium');

    if (Platform.isWindows) {
      await _initializeWindowsStore();
      return;
    }

    // Skip store setup on platforms that don't support IAP
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
    if (Platform.isWindows) return _buyUnlockAllWindows();

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
      return await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('[IAP] Buy error: $e');
      _loading = false;
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (Platform.isWindows) {
      await _restoreWindowsPurchases();
      return;
    }

    if (!_storeAvailable) return;
    await InAppPurchase.instance.restorePurchases();
  }

  Future<String?> fetchLocalizedPrice() async {
    if (Platform.isWindows) {
      return _fetchWindowsLocalizedPrice();
    }

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

  bool get _isSupportedPlatform => Platform.isIOS || Platform.isAndroid || Platform.isMacOS || Platform.isWindows;

  Future<void> _loadProductDetails() async {
    if (Platform.isWindows) {
      await _loadWindowsProductDetails();
      return;
    }

    final response = await InAppPurchase.instance.queryProductDetails({kUnlockAllStoriesProductId});
    if (response.productDetails.isNotEmpty) {
      _productDetails = response.productDetails.first;
      debugPrint('[IAP] Product loaded: ${_productDetails!.title} — ${_productDetails!.price}');
    } else {
      debugPrint('[IAP] Product not found. Not-found IDs: ${response.notFoundIDs}');
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
    await _setPremium(true);
  }

  Future<void> _initializeWindowsStore() async {
    try {
      _storeAvailable = await _windowsIapChannel.invokeMethod<bool>('isStoreAvailable') ?? false;
    } catch (e) {
      _storeAvailable = false;
      debugPrint('[IAP][Windows] Store unavailable: $e');
    }

    if (!_storeAvailable) {
      debugPrint('[IAP][Windows] Store is not available. App must run as packaged MSIX.');
      return;
    }

    await _loadWindowsProductDetails();
    await _restoreWindowsPurchases();
  }

  Future<bool> _buyUnlockAllWindows() async {
    if (!_storeAvailable) {
      debugPrint('[IAP][Windows] Store not available');
      return false;
    }
    if (_loading) return false;

    _loading = true;
    try {
      final raw = await _windowsIapChannel.invokeMapMethod<String, dynamic>('purchaseProduct', {
        'productId': kWindowsUnlockAllStoreId,
      });
      final payload = raw ?? const <String, dynamic>{};
      final success = payload['success'] == true;
      final alreadyOwned = payload['alreadyOwned'] == true;
      if (success || alreadyOwned) {
        debugPrint('[IAP][Windows] Purchase unlocked. status=${payload['status']}');
        await _setPremium(true);
        return true;
      }
      _loading = false;
      debugPrint('[IAP][Windows] Purchase did not complete. status=${payload['status']}');
      return false;
    } catch (e) {
      _loading = false;
      debugPrint('[IAP][Windows] Buy error: $e');
      return false;
    }
  }

  Future<void> _restoreWindowsPurchases() async {
    if (!_storeAvailable) return;
    try {
      final owned = await _windowsIapChannel.invokeMethod<bool>('hasPurchasedProduct', {
        'productId': kWindowsUnlockAllStoreId,
      });
      if (owned == true) {
        debugPrint('[IAP][Windows] Existing entitlement found');
        await _setPremium(true);
      }
    } catch (e) {
      debugPrint('[IAP][Windows] Restore failed: $e');
    } finally {
      _loading = false;
    }
  }

  Future<String?> _fetchWindowsLocalizedPrice() async {
    if (!_storeAvailable) {
      try {
        _storeAvailable = await _windowsIapChannel.invokeMethod<bool>('isStoreAvailable') ?? false;
      } catch (e) {
        debugPrint('[IAP][Windows] Store availability error: $e');
        _storeAvailable = false;
      }
      if (!_storeAvailable) return null;
    }

    if (_windowsLocalizedPrice == null) {
      await _loadWindowsProductDetails();
    }
    return _windowsLocalizedPrice;
  }

  Future<void> _loadWindowsProductDetails() async {
    try {
      _windowsLocalizedPrice = await _windowsIapChannel.invokeMethod<String>('getProductPrice', {
        'productId': kWindowsUnlockAllStoreId,
      });
      if (_windowsLocalizedPrice != null) {
        debugPrint('[IAP][Windows] Product price: $_windowsLocalizedPrice');
      } else {
        debugPrint('[IAP][Windows] Product not found: $kWindowsUnlockAllStoreId');
      }
    } catch (e) {
      debugPrint('[IAP][Windows] Product lookup error: $e');
    }
  }

  Future<void> _setPremium(bool value) async {
    _isPremium = value;
    _loading = false;
    await SettingsService.setBool(kPremiumPrefKey, value);
    _statusController.add(value);
  }
}
