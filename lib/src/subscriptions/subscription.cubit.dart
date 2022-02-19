import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qs_purchase/src/api/purchase.controller.dart';
import 'package:qs_purchase/src/api/purchase.delegate.dart';
import 'package:qs_purchase/src/data/purchase_error.dart';
import 'package:qs_purchase/src/data/subscription.dto.dart';
import 'package:qs_purchase/src/data/subscription_state.dto.dart';
import 'package:qs_purchase/src/subscriptions/local_user.store.dart';

const kQonversionApiKey = 'QonversionApiKey';
const kQonversionSubscriptionPermissions = 'QonversionSubscriptionPermissions';

const _kSubscriptionStatus = 'subscriptionStatus';

class SubscriptionState {
  final SubscriptionStateDto stateDto;
  final bool isLoaded;

  SubscriptionState({
    required this.stateDto,
    this.isLoaded = false,
  });

  bool get isSubscribed => stateDto.isSubscribed;
}

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final String? userKey;
  PurchaseController? _controller;

  SubscriptionCubit(this.userKey)
      : super(SubscriptionState(
          stateDto: SubscriptionStateDto(isSubscribed: false),
        ));

  Future<void> init(
    BuildContext context,
    PurchaseDelegate delegate,
  ) async {
    final localStateString =
        await PurchaseUserStore.of(userKey).getString(_kSubscriptionStatus);
    if (localStateString != null) {
      final restoredDto =
          SubscriptionStateDto.fromJson(jsonDecode(localStateString));
      emit(SubscriptionState(stateDto: restoredDto, isLoaded: true));
    } else {
      emit(SubscriptionState(stateDto: state.stateDto, isLoaded: true));
    }
    _controller = PurchaseController(userKey: userKey, delegate: delegate);
    await _controller!.init(context).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
    await sync(context);
  }

  Future<bool> sync(BuildContext context) async {
    if (_controller == null) {
      return false;
    }
    try {
      final statusResult =
          await _controller!.getCurrentSubscriptionState(context);
      if (statusResult.isSubscribed != state.stateDto.isSubscribed) {
        // Save last state for faster restore when loading app
        await PurchaseUserStore.of(userKey).saveString(
          _kSubscriptionStatus,
          jsonEncode(statusResult.toJson()),
        );
        // Update current state
        emit(SubscriptionState(stateDto: statusResult, isLoaded: true));
      }
      return statusResult.isSubscribed;
    } catch (e) {
      if (kDebugMode) {
        print('Subscription sync error: $e');
      }
      return false;
    }
  }

  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    if (_controller == null) {
      return [];
    }
    return await _controller!.getSubscriptionDetails(context, products);
  }

  //Return true if purchase process was started
  Future<void> purchase(
    BuildContext context,
    String productId, {
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
    Function(PurchaseError error)? onError,
  }) async {
    if (_controller == null) {
      onError?.call(PurchaseError.notInitialized);
      return;
    }
    bool isSuccess = false;
    PurchaseError? resultError;
    await _controller!.purchaseSubscription(
      context,
      productId,
      onSuccess: () => isSuccess = true,
      onCancel: onCancel,
      onError: (error) => resultError = error,
    );
    if (isSuccess) {
      await sync(context);
      onSuccess?.call();
    } else if (resultError != null) {
      if (resultError == PurchaseError.alreadyPurchased) {
        await sync(context);
      }
      onError?.call(resultError!);
    }
  }
}
