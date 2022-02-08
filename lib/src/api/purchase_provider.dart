import 'package:flutter/widgets.dart';
import 'package:qs_purchase/src/api/purchase_event_listener.dart';
import 'package:qs_purchase/src/api/purchase_provider_params.dart';
import 'package:qs_purchase/src/api/subscription.dto.dart';
import 'package:qs_purchase/src/api/subscription_status.dto.dart';

import 'purchase.mobile.dart'
    if (dart.library.html) 'purchase.web.dart'
    if (dart.library.io) 'purchase.mobile.dart';

mixin BasePurchaseProvider {
  final listeners = <PurchaseEventListener>[];

  late String? userKey;

  Future<void> init(BuildContext context, PurchaseProviderParams params);

  Future<void> syncPurchases();

  Future<bool> purchaseSubscription(BuildContext context, String productId);

  Future<SubscriptionStatusDto> getCurrentSubscriptionStatus(
    BuildContext context,
  );

  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  );

  void notifyPurchaseSuccess(String productId) {
    for (var e in listeners) {
      e.onPurchaseSuccess(productId);
    }
  }

  void notifyPurchaseCancel(String productId) {
    for (var e in listeners) {
      e.onPurchaseCancel(productId);
    }
  }

  void notifyPurhcaseError(String productId) {
    for (var e in listeners) {
      e.onPurchaseError(productId);
    }
  }
}

class PurchaseProvider with BasePurchaseProvider {
  final PurchasePlatform _instance = PurchasePlatform();

  PurchaseProvider({String? userKey}) {
    _instance.userKey = userKey;
  }

  @override
  Future<void> init(BuildContext context, PurchaseProviderParams params) =>
      _instance.init(context, params);

  @override
  Future<void> syncPurchases() => _instance.syncPurchases();

  @override
  Future<bool> purchaseSubscription(
    BuildContext context,
    String productId,
  ) async {
    final currentStatus = await getCurrentSubscriptionStatus(context);
    if (currentStatus.isSubscribed) {
      throw currentStatus;
    }
    final result = _instance.purchaseSubscription(context, productId);
    return result;
  }

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) =>
      _instance.getSubscriptionDetails(context, products);

  @override
  Future<SubscriptionStatusDto> getCurrentSubscriptionStatus(
    BuildContext context,
  ) =>
      _instance.getCurrentSubscriptionStatus(context);
}
