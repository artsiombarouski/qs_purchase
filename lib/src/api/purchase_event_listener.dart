import 'package:qs_purchase/src/data/purchased_product.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';

/// Listener useful for analytics:
///
/// final _kIsAndroid = defaultTargetPlatform == TargetPlatform.android;
///
/// class PurchaseAnalyticsListener extends PurchaseEventListener {
///   @override
///   void onPurchaseSuccess(PurchasedProduct product) {
///     Analytics.event('subscribeSuccess', params: {
///       'productId': product.id,
///       Analytics.kPlatform: _kIsAndroid ? 'android' : 'ios',
///     });
///   }
///
///   @override
///   void onPurchaseCancel(String productId) {
///     Analytics.event('subscribeCancel', params: {
///       'productId': productId,
///       Analytics.kPlatform: _kIsAndroid ? 'android' : 'ios',
///     });
///   }
///
///   @override
///   void onPurchaseError(String productId) {
///     Analytics.event('subscribeError', params: {
///       'productId': productId,
///       Analytics.kPlatform: _kIsAndroid ? 'android' : 'ios',
///     });
///   }
/// }
///
class PurchaseEventListener {
  void onPurchaseSuccess(PurchasedProduct product) {}

  void onPurchaseCancel(String productId) {}

  void onPurchaseError(String productId, PurchaseError error) {}
}
