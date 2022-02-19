import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qs_purchase/qs_purchase.dart';
import 'package:qs_purchase/src/api/purchase.delegate.dart';
import 'package:qs_purchase/src/api/purchase_event_listener.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';

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
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) async {
    final currentStatus = await getCurrentSubscriptionState(context);
    if (currentStatus.isSubscribed) {
      notifyPurhcaseError(productId, PurchaseError.alreadyPurchased);
      onError?.call(PurchaseError.alreadyPurchased);
      return;
    }
    return delegate.purchaseSubscription(
      context,
      productId,
      onSuccess: () {
        notifyPurchaseSuccess(productId);
        onSuccess?.call();
      },
      onCancel: () {
        notifyPurchaseCancel(productId);
        onCancel?.call();
      },
      onError: (error) {
        notifyPurhcaseError(productId, error);
        onError?.call(error);
      },
    ).catchError((e) {
      if (kDebugMode) {
        print('PurchaseError: $e');
      }
      notifyPurhcaseError(productId, PurchaseError.unknown);
      onError?.call(PurchaseError.unknown);
    });
  }

  @override
  Future<void> syncPurchases() {
    return delegate.syncPurchases();
  }

  void notifyPurchaseSuccess(String productId) {
    for (var e in listeners) {
      e.onPurchaseSuccess(productId);
    }
  }

  void notifyPurchaseCancel(String productId) {
    for (var e in listeners) {
      e.onPurchaseCancel(productId);
    }
  }

  void notifyPurhcaseError(String productId, PurchaseError error) {
    for (var e in listeners) {
      e.onPurchaseError(productId, error);
    }
  }
}
