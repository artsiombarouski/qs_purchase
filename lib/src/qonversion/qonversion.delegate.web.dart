import 'package:flutter/widgets.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';
import 'package:qs_purchase/src/data/purchased_product.dart';
import 'package:qs_purchase/src/data/subscription.dto.dart';
import 'package:qs_purchase/src/data/subscription_state.dto.dart';
import 'package:qs_purchase/src/qonversion/qonversion.delegate.dart';

class QonversionPlatformDelegate extends QonversionDelegate {
  QonversionPlatformDelegate({
    required String apiKey,
    List<String> subscriptionPermissions = const [],
    bool isDebug = false,
  }) : super(
          apiKey: apiKey,
          subscriptionPermissions: subscriptionPermissions,
          isDebug: isDebug,
        );

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<SubscriptionStateDto> getCurrentSubscriptionState(
      BuildContext context) {
    // TODO: implement getCurrentSubscriptionState
    throw UnimplementedError();
  }

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
      BuildContext context, List<String> products) {
    // TODO: implement getSubscriptionDetails
    throw UnimplementedError();
  }

  @override
  Future<void> init(BuildContext context) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> purchaseSubscription(
    BuildContext context,
    String productId, {
    Function(PurchasedProduct product)? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) {
    // TODO: implement purchaseSubscription
    throw UnimplementedError();
  }

  @override
  Future<void> syncPurchases() {
    // TODO: implement syncPurchases
    throw UnimplementedError();
  }
}
