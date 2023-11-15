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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'currency': currency,
      'type': type.toString(),
    };
  }

  factory PurchasedProduct.fromMap(Map<String, dynamic> map) {
    return PurchasedProduct(
      map['id'] as String,
      map['price'] as double?,
      map['currency'] as String?,
      map['type']
          ? QsProductType.values.byName(map['type'])
          : QsProductType.unknown,
    );
  }
}
