import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Premium unlock purchase, replacing the native `tauri-plugin-iap` Swift
/// plugin. `in_app_purchase` wraps StoreKit2 on iOS and Play Billing on
/// Android through Flutter's own maintained plugin — this sidesteps the
/// whole class of Swift-Concurrency/StoreKit2 runtime crashes the old
/// vendored plugin needed manual patching for (see project history:
/// Simulator `Transaction.updates` crash, then a real-device crash caused
/// by the app's iOS deployment target being lower than what StoreKit2's
/// async APIs need).
class IapService {
  IapService() {
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate);
  }

  static String get premiumProductId =>
      Platform.isAndroid ? 'tsuzuki_connect_unlock_all' : 'tsuzuki_connect_unlock_all';

  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  final _ownedController = StreamController<bool>.broadcast();
  Stream<bool> get isPremiumOwned => _ownedController.stream;

  Future<bool> get isAvailable => _iap.isAvailable();

  Future<ProductDetailsResponse> getProducts() {
    return _iap.queryProductDetails({premiumProductId});
  }

  Future<void> buyPremium(ProductDetails product) {
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      debugPrint(
        'IAP purchase update: ${purchase.productID} ${purchase.status} '
        '${purchase.pendingCompletePurchase}',
      );
      if (purchase.productID != premiumProductId) continue;
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        _ownedController.add(true);
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription.cancel();
    _ownedController.close();
  }
}
