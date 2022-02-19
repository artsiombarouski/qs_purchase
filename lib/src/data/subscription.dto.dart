import 'package:qs_purchase/src/data/subscription_billing_period.dart';

class SubscriptionDto {
  final String productId;
  final String displayPrice;
  final SubscriptionBillingPeriod? billingPeriod;
  final int? trialDurationDays;

  SubscriptionDto({
    required this.productId,
    required this.displayPrice,
    required this.billingPeriod,
    this.trialDurationDays,
  });
}
