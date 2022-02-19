import 'package:shared_preferences/shared_preferences.dart';

class PurchaseUserStore {
  static final _instances = <String?, PurchaseUserStore>{};

  static PurchaseUserStore of(String? userId) {
    PurchaseUserStore? instance = _instances[userId];
    if (instance == null) {
      instance = PurchaseUserStore(userKey: userId);
      _instances[userId] = instance;
    }
    return instance;
  }

  final String? userKey;

  PurchaseUserStore({required this.userKey});

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
