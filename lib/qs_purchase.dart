import 'package:flutter/services.dart';

export 'package:qs_purchase/src/api/purchase_provider_params.dart';
export 'package:qs_purchase/src/api/subscription.dto.dart';
export 'package:qs_purchase/src/api/subscription_status.dto.dart';
export 'package:qs_purchase/src/subscription.cubit.dart';

class QsPurchase {
  static const MethodChannel _channel = MethodChannel('qs_purchase');
}
