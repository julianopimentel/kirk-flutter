import 'package:KirkDigital/network/api_me.dart';
import 'package:KirkDigital/provider/list_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/auth_token.dart';
import '../model/person_me.dart';
import '../model/user_list.dart';
import '../model/users_me.dart';
import '../network/api_UserList.dart';
import '../network/api_client.dart';
import '../service/notification_service.dart';
import '../ui/ListAccountPage.dart';

class AccountProvider with ChangeNotifier {
  String? _token;
  String? _userInstance;
  String? _dadosDaPessoa;
  late final SharedPreferences _preferences;
  List<Account> _accountList = []; // Lista de contas

  String? get token => _token;
  String? get userInstance => _userInstance;
  String? get dadosDaPessoa => _dadosDaPessoa;
  List<Account> get accountList => _accountList;

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

    //salvar o token no shared_preferences
    await _preferences.setString(AppConstant.keyToken, auth.token!);
    notifyListeners();
    return auth;
  }

  Future<void> loginNovo({
    required String email,
    required String password,
    required context,
  }) async {
    AuthToken auth = await ApiClient.login(
      email: email,
      password: password,
    );
    _token = auth.token;

    if (auth.token == null) {
      NotificationService.showNotification(auth.message ?? 'Seu email ou senha estão incorretos', NotificationType.warning, context);
      return;
    }

    //salvar o token no shared_preferences
    await _preferences.setString(AppConstant.keyToken, auth.token!);

    //verificar quis contas o usuario tem acesso
    List<Map<String, dynamic>> jsonList =
    await ApiUserList.getSchema(); // Obtenha a lista de contas

    //retornar se a lista de contas for vazia
    if (jsonList.isEmpty) {
      NotificationService.showNotification('Você não tem acesso a nenhuma conta', NotificationType.warning, context);
      return;
    }
    List<Account> accounts = jsonList.map((json) => Account.fromJson(json)).toList();

    _accountList = accounts; // Armazene a lista de contas no provider

    //se o usuario tiver acesso a apenas uma conta, seleciona-la automaticamente
    if (_accountList.length == 1) {
      ListAccountProvider listAccountProvider = Provider.of<ListAccountProvider>(context, listen: false);
      _preferences.setBool('keyMultiConta', false);

      listAccountProvider.setSchema(
          tenantId: _accountList[0].tenantId,
          personId: _accountList[0].personId,
          name_conta: _accountList[0].nameConta,
          context: context
      );
      notifyListeners(); // Notifique os ouvintes sobre a atualização
    }
    else {
      _preferences.setBool('keyMultiConta', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ListAccountPage();
            },
          ),
              (Route<dynamic> route) => false,
        );
      notifyListeners(); // Notifique os ouvintes sobre a atualização
    }
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

      logout();
      notifyListeners();

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
    String? token = await FirebaseMessaging.instance.getToken();
    await ApiMe.removeToken(app_id: token!);
    //remover o token do firebase
    //remover o token do shared preferences
    await _preferences.remove(AppConstant.keyToken);
    await _preferences.remove(AppConstant.keyUserInstance);
    await _preferences.remove(AppConstant.keyDadosPessoais);
    await _preferences.remove(AppConstant.keyPermission);

    await _preferences.remove(AppConstant.keyPersonId);
    await _preferences.remove(AppConstant.keyNameConta);
    await _preferences.remove(AppConstant.keyUserInstance);
    _preferences.remove('_token');
    await _preferences.remove(AppConstant.tokenNotification);
    _preferences.clear();

    return;
  }
}
