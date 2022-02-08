enum SubscriptionBillingPeriod {
  day,
  week,
  month,
  year,
  lifetime,
}

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
