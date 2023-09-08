import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../common/token_manager.dart';
import '../model/auth_token.dart';
import '../model/users_me.dart';
import '../network/api_client.dart';
import '../service/notification_service.dart';

class AccountProvider with ChangeNotifier {
  String? _token;
  String? _userInstance;
  late final SharedPreferences _preferences;

  String? get token => _token;
  String? get userInstance => _userInstance;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(AppConstant.keyToken);
    _userInstance = _preferences.getString(AppConstant.keyUserInstance);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await ApiClient.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<AuthToken> login({
    required String email,
    required String password,
  }) async {
    AuthToken auth = await ApiClient.login(
      email: email,
      password: password,
    );
    _token = auth.token;
    if (auth.token != null) {
      await _preferences.setString(
        AppConstant.keyToken,
        auth.token!,
      );
      //salvar token no shared preferences
      TokenManager().setTokenFromJson(auth.token!);
    }

    notifyListeners();
    return auth;
  }

  UsersMe getMe() {
    UsersMe user = UsersMe.fromJwtToken(_token!);
    return user;
  }

  Future<void> logout() async {
    _token = null;
    TokenManager().removeSchema();
    await _preferences.remove(AppConstant.keyToken);
    notifyListeners();
  }
}
