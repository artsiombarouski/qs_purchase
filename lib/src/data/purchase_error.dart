class PurchaseError {
  static const unknown = PurchaseError('unknown');
  static const alreadyPurchased = PurchaseError('alreadyPurchased');
  static const notInitialized = PurchaseError('notInitialized');

  final String key;
  final String? title;
  final String? message;

  const PurchaseError(this.key, {this.title, this.message});

  String get displayTitle => title ?? key;

  String? get displayMessage => message;

  @override
  String toString() {
    return "PurchaseError: $key";
  }
}
