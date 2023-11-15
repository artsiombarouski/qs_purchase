import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';
import 'package:qs_purchase/src/data/purchased_product.dart';
import 'package:qs_purchase/src/data/subscription.dto.dart';
import 'package:qs_purchase/src/data/subscription_state.dto.dart';
import 'package:qs_purchase/src/qonversion/qonversion.delegate.dart';
import 'package:qs_purchase/src/qonversion/qonversion.utils.dart';

class QonversionPlatformDelegate extends QonversionDelegate {
  late Qonversion _instance;

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
  Future<void> init(BuildContext context) async {
    final config = QonversionConfigBuilder(
      apiKey,
      QLaunchMode.subscriptionManagement,
    );
    if (isDebug) {
      config.setEnvironment(QEnvironment.sandbox);
    }
    _instance = Qonversion.initialize(config.build());
    await _identifyUser();
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    final apiProducts = await _instance.products();
    final List<SubscriptionDto> result = [];
    for (var productKey in products) {
      final value = apiProducts[productKey];
      if (value == null) {
        continue;
      }
      final String? price = value.prettyPrice;
      if (price == null) {
        continue;
      }
      final dto = SubscriptionDto(
        productId: productKey,
        displayPrice: price,
        billingPeriod: durationToBillingPeriod(value.duration),
        trialDurationDays: trialDurationToDays(value.trialDuration),
      );
      result.add(dto);
    }
    return result;
  }

  @override
  Future<SubscriptionStateDto> getCurrentSubscriptionState(
    BuildContext context,
  ) async {
    final entitlements = await _instance.checkEntitlements();
    final matchingEntitlement = entitlements.values.firstWhereOrNull(
      (element) =>
          subscriptionPermissions.contains(element.id) && element.isActive,
    );
    return SubscriptionStateDto(
      isSubscribed: matchingEntitlement?.isActive == true,
    );
  }

  @override
  Future<void> syncPurchases() async {
    await _identifyUser();
    await _instance.syncPurchases();
  }

  @override
  Future<void> purchaseSubscription(
    BuildContext context,
    String productId, {
    Function(PurchasedProduct product)? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) async {
    try {
      await _identifyUser();
      await _instance.purchase(productId);
      final productInfo = await _instance.products().then((value) {
        return value[productId];
      });
      onSuccess?.call(PurchasedProduct(
        productId,
        productInfo?.price,
        productInfo?.currencyCode,
        qonversionProductTypeToQsProductType(productInfo?.type),
      ));
    } on QPurchaseException catch (e) {
      if (e.isUserCancelled) {
        onCancel?.call();
      } else {
        onError?.call(PurchaseError(e.code,
            title: e.message, message: e.additionalMessage));
      }
    }
  }

  Future<void> _identifyUser() async {
    final userKey = controller.userKey;
    if (userKey != null) {
      _instance.setUserProperty(QUserPropertyKey.customUserId, userKey);
    }
  }
}
