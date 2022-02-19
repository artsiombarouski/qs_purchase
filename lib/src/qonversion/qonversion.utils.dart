import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qs_purchase/src/data/subscription_billing_period.dart';

SubscriptionBillingPeriod? durationToBillingPeriod(QProductDuration? duration) {
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

int? trialDurationToDays(QTrialDuration? duration) {
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
