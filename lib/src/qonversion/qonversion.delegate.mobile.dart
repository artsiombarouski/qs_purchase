import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';
import 'package:qs_purchase/src/data/subscription.dto.dart';
import 'package:qs_purchase/src/data/subscription_state.dto.dart';
import 'package:qs_purchase/src/qonversion/qonversion.delegate.dart';
import 'package:qs_purchase/src/qonversion/qonversion.utils.dart';

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
  Future<void> init(BuildContext context) async {
    await Qonversion.launch(apiKey, isObserveMode: false);
    await _identifyUser();
    if (isDebug) {
      await Qonversion.setDebugMode();
    }
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    final apiProducts = await Qonversion.products();
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
    final permissions = await Qonversion.checkPermissions();
    final apiPermission = permissions.entries
        .firstWhereOrNull((element) =>
            subscriptionPermissions.contains(element.value.permissionId) &&
            element.value.isActive)
        ?.value;
    return SubscriptionStateDto(isSubscribed: apiPermission?.isActive == true);
  }

  @override
  Future<void> syncPurchases() async {
    await _identifyUser();
    await Qonversion.syncPurchases();
  }

  @override
  Future<void> purchaseSubscription(
    BuildContext context,
    String productId, {
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) async {
    try {
      await _identifyUser();
      await Qonversion.purchase(productId);
      onSuccess?.call();
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
      await Qonversion.setUserId(userKey);
    }
  }
}
