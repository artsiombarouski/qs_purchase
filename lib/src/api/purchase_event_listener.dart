import 'package:qs_purchase/src/data/purchase_error.dart';

/// Listener useful for analytics:
///
/// final _kIsAndroid = defaultTargetPlatform == TargetPlatform.android;
///
/// class PurchaseAnalyticsListener extends PurchaseEventListener {
///   @override
///   void onPurchaseSuccess(String productId) {
///     Analytics.event('subscribeSuccess', params: {
///       'productId': productId,
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
  void onPurchaseSuccess(String productId) {}

  void onPurchaseCancel(String productId) {}

  void onPurchaseError(String productId, PurchaseError error) {}
}
