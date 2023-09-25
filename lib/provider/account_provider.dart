import 'package:KirkDigital/network/api_me.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../common/token_manager.dart';
import '../model/auth_token.dart';
import '../model/person_me.dart';
import '../model/users_me.dart';
import '../network/api_client.dart';

class AccountProvider with ChangeNotifier {
  String? _token;
  String? _userInstance;
  String? _dadosDaPessoa;
  late final SharedPreferences _preferences;

  String? get token => _token;
  String? get userInstance => _userInstance;
  String? get dadosDaPessoa => _dadosDaPessoa;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(AppConstant.keyToken);
    _userInstance = _preferences.getString(AppConstant.keyUserInstance);
    _dadosDaPessoa = _preferences.getString(AppConstant.keyDadosPessoais);
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
      //TokenManager().setTokenFromJson(auth.token!);
    }

    notifyListeners();
    return auth;
  }

  UsersMe getMe() {
    UsersMe user = UsersMe.fromJwtToken(_token!);
    return user;
  }

  Future<PersonMe> getDadosPessoais() async {
    try {
      PersonMe personMe = await ApiMe.getMe();

      notifyListeners();
      return personMe;
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
      throw Exception('Erro ao buscar os dados');
    }
  }

  Future<PersonMe> putDadosPessoais({
    required String name,
    required String phone,
    required String image,
  }) async {
    try {
      await ApiMe.postMe(
        name: name,
        phone: phone,
        image: image,
      );
      PersonMe personMe = await ApiMe.getMe();
      return personMe;
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao atualizar os dados: $error");
      throw Exception('Erro ao atualizar os dados');
    }
  }


  Future<void> logout() async {
    //remover o token do shared preferences
    await _preferences.remove(AppConstant.keyToken);
    await _preferences.remove(AppConstant.keyUserInstance);
    await _preferences.remove(AppConstant.keyDadosPessoais);
    _preferences.remove('_token');

    _preferences.clear();
  }
}
