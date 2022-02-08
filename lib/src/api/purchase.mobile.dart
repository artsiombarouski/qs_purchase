import 'package:flutter/widgets.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qs_purchase/qs_purchase.dart';
import 'package:qs_purchase/src/api/purchase_provider.dart';

class PurchasePlatform with BasePurchaseProvider {
  final List<String> _subscriptionPermissions = [];

  @override
  Future<void> init(
    BuildContext context,
    PurchaseProviderParams params,
  ) async {
    final String? apiKey = params.custom?[kQonversionApiKey];
    if (apiKey == null) {
      throw Exception('Qonversion api key not provided');
    }
    List<String>? subscriptionPermissions =
        params.custom?[kQonversionSubscriptionPermissions];
    if (subscriptionPermissions != null) {
      _subscriptionPermissions.addAll(subscriptionPermissions);
    }
    await Qonversion.launch(apiKey, isObserveMode: false);
    if (userKey != null) {
      await Qonversion.setUserId(userKey!);
    }
    if (params.isDebug) {
      await Qonversion.setDebugMode();
    }
  }

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    final apiProducts = await Qonversion.products();
    final List<SubscriptionDto> result = [];
    for (var productKey in products) {
      final value = apiProducts[productKey];
      if (value != null) {
        final String? price = value.prettyPrice;
        if (price != null) {
          final dto = SubscriptionDto(
            productId: productKey,
            displayPrice: price,
            billingPeriod: _durationToBillingPeriod(value.duration),
            trialDurationDays: _trialDurationToDays(value.trialDuration),
          );
          result.add(dto);
        }
      }
    }
    return result;
  }

  @override
  Future<SubscriptionStatusDto> getCurrentSubscriptionStatus(
    BuildContext context,
  ) async {
    final permissions = await Qonversion.checkPermissions();
    final bool subscribed = permissions.entries.any((element) =>
        _subscriptionPermissions.contains(element.value.permissionId) &&
        element.value.isActive);
    return SubscriptionStatusDto(isSubscribed: subscribed);
  }

  @override
  Future<bool> purchaseSubscription(
    BuildContext context,
    String productId,
  ) async {
    try {
      if (userKey != null) {
        await Qonversion.identify(userKey!);
      }
      await Qonversion.purchase(productId);
      notifyPurchaseSuccess(productId);
      return true;
    } on QPurchaseException catch (e) {
      if (e.isUserCancelled) {
        notifyPurchaseCancel(productId);
      } else {
        notifyPurhcaseError(productId);
      }
      return false;
    }
  }

  @override
  Future<void> syncPurchases() async {
    if (userKey != null) {
      await Qonversion.identify(userKey!);
    }
    await Qonversion.syncPurchases();
  }

  SubscriptionBillingPeriod? _durationToBillingPeriod(
      QProductDuration? duration) {
    switch (duration) {
      case QProductDuration.weekly:
        return SubscriptionBillingPeriod.week;
      case QProductDuration.monthly:
        return SubscriptionBillingPeriod.month;
      case QProductDuration.annual:
        return SubscriptionBillingPeriod.year;
      case QProductDuration.lifetime:
        return SubscriptionBillingPeriod.lifetime;
      default:
        return null;
    }
  }

  int? _trialDurationToDays(QTrialDuration? duration) {
    switch (duration) {
      case QTrialDuration.threeDays:
        return 3;
      case QTrialDuration.week:
        return 7;
      case QTrialDuration.twoWeeks:
        return 14;
      case QTrialDuration.month:
        return 30;
      case QTrialDuration.year:
        return 365;
      default:
        return null;
    }
  }
}
