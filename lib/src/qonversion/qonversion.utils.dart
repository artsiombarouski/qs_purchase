import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:qs_purchase/src/data/purchased_product.dart';
import 'package:qs_purchase/src/data/subscription_billing_period.dart';

SubscriptionBillingPeriod? durationToBillingPeriod(
  QSubscriptionPeriod? period,
) {
  switch (period?.unit) {
    case QSubscriptionPeriodUnit.week:
      return SubscriptionBillingPeriod.week;
    case QSubscriptionPeriodUnit.month:
      return SubscriptionBillingPeriod.month;
    case QSubscriptionPeriodUnit.year:
      return SubscriptionBillingPeriod.year;
    default:
      return null;
  }
}

int? trialDurationToDays(QSubscriptionPeriod? period) {
  switch (period?.unit) {
    case QSubscriptionPeriodUnit.day:
      return period?.unitCount;
    case QSubscriptionPeriodUnit.week:
      return 7 * period!.unitCount;
    case QSubscriptionPeriodUnit.month:
      return 30 * period!.unitCount;
    case QSubscriptionPeriodUnit.year:
      return 365 * period!.unitCount;
    default:
      return null;
  }
}

QsProductType qonversionProductTypeToQsProductType(QProductType? type) {
  switch (type) {
    case QProductType.trial:
      return QsProductType.trial;
    case QProductType.inApp:
      return QsProductType.inApp;
    case QProductType.subscription:
      return QsProductType.subscription;
    default:
      return QsProductType.unknown;
  }
}
