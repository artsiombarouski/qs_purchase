import 'package:qs_purchase/src/api/purchase.controller.dart';
import 'package:qs_purchase/src/api/purchase.delegate.dart';

import 'qonversion.delegate.mobile.dart'
    if (dart.library.html) 'qonversion.delegate.web.dart'
    if (dart.library.io) 'qonversion.delegate.mobile.dart';

abstract class QonversionDelegate with PurchaseDelegate {
  final String apiKey;
  final List<String> subscriptionPermissions;
  final bool isDebug;

  QonversionDelegate({
    required this.apiKey,
    this.subscriptionPermissions = const [],
    this.isDebug = false,
  });

  static QonversionDelegate create({
    required String apiKey,
    List<String> subscriptionPermissions = const [],
    bool isDebug = false,
  }) =>
      QonversionPlatformDelegate(
          apiKey: apiKey,
          subscriptionPermissions: subscriptionPermissions,
          isDebug: isDebug);
}
