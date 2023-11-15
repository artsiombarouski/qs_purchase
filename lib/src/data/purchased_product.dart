enum QsProductType {
  trial,
  subscription,
  inApp,
  unknown,
}

class PurchasedProduct {
  final String id;
  final double? price;
  final String? currency;
  final QsProductType type;

  PurchasedProduct(
    this.id,
    this.price,
    this.currency,
    this.type,
  );
}
