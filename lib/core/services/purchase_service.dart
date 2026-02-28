import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  throw UnimplementedError('Overridden in main.dart');
});

class PurchaseService {
  PurchaseService._(this._prefs);

  static const premiumProductId = 'no_ai_coding_gym_premium_unlock';

  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static Future<PurchaseService> create(SharedPreferences prefs) async {
    return PurchaseService._(prefs);
  }

  bool get isPremium => _prefs.getBool('isPremium') ?? false;

  Future<void> init() async {
    _subscription = _inAppPurchase.purchaseStream.listen(_onPurchaseUpdated);
  }

  Future<ProductDetails?> loadPremiumProduct() async {
    final response = await _inAppPurchase.queryProductDetails({premiumProductId});
    if (response.error != null || response.productDetails.isEmpty) {
      return null;
    }
    return response.productDetails.first;
  }

  Future<bool> buyPremium(ProductDetails details) async {
    final param = PurchaseParam(productDetails: details);
    return _inAppPurchase.buyNonConsumable(purchaseParam: param);
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _prefs.setBool('isPremium', true);
      }
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
