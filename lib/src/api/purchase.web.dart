import 'package:flutter/widgets.dart';
import 'package:qs_purchase/src/api/purchase_provider.dart';
import 'package:qs_purchase/src/api/purchase_provider_params.dart';
import 'package:qs_purchase/src/api/subscription.dto.dart';
import 'package:qs_purchase/src/api/subscription_status.dto.dart';

class PurchasePlatform with BasePurchaseProvider {
  @override
  Future<void> init(
    BuildContext context,
    PurchaseProviderParams params,
  ) async {}

  @override
  Future<void> syncPurchases() {
    throw UnsupportedError("Web purchase not supported yet");
  }

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    throw UnsupportedError("Web purchase not supported yet");
  }

  @override
  Future<SubscriptionStatusDto> getCurrentSubscriptionStatus(
    BuildContext context,
  ) {
    throw UnsupportedError("Web purchase not supported yet");
  }

  @override
  Future<bool> purchaseSubscription(BuildContext context, String productId) {
    throw UnsupportedError("Web purchase not supported yet");
  }
}
