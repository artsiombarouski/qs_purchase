import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qs_purchase/qs_purchase.dart';
import 'package:qs_purchase/src/api/purchase.delegate.dart';
import 'package:qs_purchase/src/api/purchase_event_listener.dart';
import 'package:qs_purchase/src/data/purchased_product.dart';

class PurchaseController with PurchaseDelegate {
  final listeners = <PurchaseEventListener>[];

  final String? userKey;
  final PurchaseDelegate delegate;

  PurchaseController({
    this.userKey,
    required this.delegate,
  }) {
    delegate.controller = this;
  }

  @override
  Future<void> init(BuildContext context) async {
    await delegate.init(context);
  }

  @override
  Future<void> dispose() async {
    await delegate.dispose();
  }

  @override
  Future<SubscriptionStateDto> getCurrentSubscriptionState(
      BuildContext context) {
    return delegate.getCurrentSubscriptionState(context);
  }

  @override
  Future<List<SubscriptionDto>> getSubscriptionDetails(
      BuildContext context, List<String> products) {
    return delegate.getSubscriptionDetails(context, products);
  }

  @override
  Future<void> purchaseSubscription(
    BuildContext context,
    String productId, {
    Function(PurchasedProduct product)? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) async {
    final currentStatus = await getCurrentSubscriptionState(context);
    if (currentStatus.isSubscribed) {
      notifyPurchaseError(productId, PurchaseError.alreadyPurchased);
      onError?.call(PurchaseError.alreadyPurchased);
      return;
    }
    return delegate.purchaseSubscription(
      context,
      productId,
      onSuccess: (product) {
        notifyPurchaseSuccess(product);
        onSuccess?.call(product);
      },
      onCancel: () {
        notifyPurchaseCancel(productId);
        onCancel?.call();
      },
      onError: (error) {
        notifyPurchaseError(productId, error);
        onError?.call(error);
      },
    ).catchError((e) {
      if (kDebugMode) {
        print('PurchaseError: $e');
      }
      notifyPurchaseError(productId, PurchaseError.unknown);
      onError?.call(PurchaseError.unknown);
    });
  }

  @override
  Future<void> syncPurchases() {
    return delegate.syncPurchases();
  }

  void notifyPurchaseSuccess(PurchasedProduct product) {
    for (var e in listeners) {
      e.onPurchaseSuccess(product);
    }
  }

  void notifyPurchaseCancel(String productId) {
    for (var e in listeners) {
      e.onPurchaseCancel(productId);
    }
  }

  void notifyPurchaseError(String productId, PurchaseError error) {
    for (var e in listeners) {
      e.onPurchaseError(productId, error);
    }
  }
}
