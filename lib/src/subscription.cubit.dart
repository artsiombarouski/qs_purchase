import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qs_purchase/src/api/purchase_provider.dart';
import 'package:qs_purchase/src/api/purchase_provider_params.dart';
import 'package:qs_purchase/src/api/subscription.dto.dart';
import 'package:qs_purchase/src/api/subscription_status.dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kQonversionApiKey = 'QonversionApiKey';
const kQonversionSubscriptionPermissions = 'QonversionSubscriptionPermissions';

const _kSubscriptionStatus = 'subscriptionStatus';

class _LocalUserStore {
  static final _instances = <String?, _LocalUserStore>{};

  static _LocalUserStore of(String? userId) {
    _LocalUserStore? instance = _instances[userId];
    if (instance == null) {
      instance = _LocalUserStore(userKey: userId);
      _instances[userId] = instance;
    }
    return instance;
  }

  final String? userKey;

  _LocalUserStore({required this.userKey});

  Future<void> saveString(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_createKey(key), data);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_createKey(key));
  }

  String _createKey(String originKey) => "${userKey}_$originKey";
}

class SubscriptionState {
  final String? userKey;
  final SubscriptionStatusDto status;
  final bool isLoaded;

  SubscriptionState({
    required this.userKey,
    required this.status,
    this.isLoaded = false,
  });

  bool get isSubscribed => status.isSubscribed;
}

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final String? userKey;
  PurchaseProvider? _purchaseProvider;

  SubscriptionCubit(this.userKey)
      : super(SubscriptionState(
          userKey: userKey,
          status: SubscriptionStatusDto(isSubscribed: false),
        ));

  Future<void> init(
    BuildContext context,
    PurchaseProviderParams params,
  ) async {
    final localStateString =
        await _LocalUserStore.of(userKey).getString(_kSubscriptionStatus);
    if (localStateString != null) {
      emit(SubscriptionState(
        userKey: userKey,
        status: SubscriptionStatusDto.fromJson(jsonDecode(localStateString)),
        isLoaded: true,
      ));
    } else {
      emit(SubscriptionState(
        userKey: userKey,
        status: state.status,
        isLoaded: true,
      ));
    }
    _purchaseProvider = PurchaseProvider(
      userKey: userKey,
    );
    await _purchaseProvider!.init(context, params).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
    await sync(context);
  }

  Future<bool> sync(BuildContext context) async {
    if (_purchaseProvider == null) {
      return false;
    }
    try {
      final statusResult =
          await _purchaseProvider!.getCurrentSubscriptionStatus(context);
      if (statusResult.isSubscribed != state.status.isSubscribed) {
        // Save last state for faster restore when loading app
        await _LocalUserStore.of(state.userKey).saveString(
          _kSubscriptionStatus,
          jsonEncode(statusResult.toJson()),
        );
        // Update current state
        emit(SubscriptionState(
          userKey: userKey,
          status: statusResult,
          isLoaded: true,
        ));
      }
      return statusResult.isSubscribed;
    } catch (e) {
      if (kDebugMode) {
        print('sync sub error: $e');
      }
      return false;
    }
  }

  Future<List<SubscriptionDto>> getSubscriptionDetails(
    BuildContext context,
    List<String> products,
  ) async {
    if (_purchaseProvider == null) {
      return [];
    }
    return await _purchaseProvider!.getSubscriptionDetails(context, products);
  }

  //Return true if purchase process was started
  Future<bool> purchase(BuildContext context, String productId) async {
    if (_purchaseProvider == null) {
      return false;
    }
    try {
      final result =
          await _purchaseProvider!.purchaseSubscription(context, productId);
      if (result) {
        await sync(context);
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Purchase error: $e');
      }
      if (e is SubscriptionStatusDto) {
        _updateStatus(e);
        return e.isSubscribed;
      }
      return false;
    }
  }

  _updateStatus(SubscriptionStatusDto dto) {
    emit(SubscriptionState(
      userKey: userKey,
      status: dto,
      isLoaded: true,
    ));
  }
}
