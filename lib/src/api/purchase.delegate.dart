import 'package:flutter/material.dart';
import 'package:qs_purchase/qs_purchase.dart';
import 'package:qs_purchase/src/api/purchase.controller.dart';
import 'package:qs_purchase/src/data/purchased_product.dart';

mixin PurchaseDelegate {
  late PurchaseController controller;

  Future<void> init(BuildContext context);

  Future<void> syncPurchases();

  Future<void> purchaseSubscription(
    BuildContext context,
    String productId, {
    Function(PurchasedProduct product)? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  });

  Future<SubscriptionStateDto> getCurrentSubscriptionState(
    BuildContext context,
  );

  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  );

  Future<void> dispose();
}
