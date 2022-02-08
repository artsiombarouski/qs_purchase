# qs_purchase

QS Library for Flutter purchase

## Getting Started

Qonversion example

```dart
Future<void> _createSubscriptionCubit(BuldContext context) async {
  final subscriptionCubit = SubscriptionCubit('TODO: your user key');
  await subscriptionCubit.init(
    context,
    PurchaseProviderParams(
      isDebug: kDebugMode,
      custom: {
        kQonversionApiKey: 'TODO: your qonversion api key',
        kQonversionSubscriptionPermissions: ['full_access'],
      },
    ),
  );
}
```

Getting subscription details

```dart
Future<SubscriptionDto> getSubscriptionDetails(BuildContext context,
    List<String> subscriptionIds,) {
  return subscriptionCubit.getSubscriptionDetails(context, subscriptionIds);
}
```

Make purchase

```dart
Future<bool> makePurchase(BuildContext context, String productId) {
  return subscriptionCubit.purchase(context, productId);
}
```