import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../common/app_constant.dart';
import '../model/auth_token.dart';
import '../model/person_me.dart';
import '../model/user_list.dart';
import '../model/users_me.dart';
import '../network/api_client.dart';
import '../network/api_me.dart';
import '../network/api_user_list.dart';
import '../ui/account/list_account_page.dart';
import '../ui/auth/login.dart';
import '../utils/toastr_utils.dart';
import 'list_account.dart';

class AccountProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  bool _isFirstLogin = true;
  String? _userInstance;
  String? _dadosDaPessoa;
  late final SharedPreferences _preferences;
  List<Account> _accountList = [];

  String? get token => _token;
  bool get isFistLogin => _isFirstLogin;
  String? get refreshToken => _refreshToken;
  String? get userInstance => _userInstance;
  String? get dadosDaPessoa => _dadosDaPessoa;
  List<Account> get accountList => _accountList;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(AppConstant.keyToken);
    _userInstance = _preferences.getString(AppConstant.keyUserInstance);
    _dadosDaPessoa = _preferences.getString(AppConstant.keyDadosPessoais);
    _isFirstLogin = _preferences.getBool(AppConstant.keyIsFirstLogin) ?? true;
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

    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      title: Text("Aguarde..."),
      message: Text("Verificando o seu usuário"),
      onDismiss: () => print("Do something onDismiss"),
    );
    progressDialog.show();

    AuthToken auth = await ApiClient.login(
      email: email,
      password: password,
    );
    _token = auth.token;
    _refreshToken = auth.refreshToken;

    if (auth.token == null) {
      NotificationUtils.showWarning(context, auth.message ?? 'Seu email ou senha estão incorretos');
      progressDialog.dismiss();
      return;
    }

    //salvar o token no shared_preferences
    await _preferences.setString(AppConstant.keyToken, auth.token!);
    await _preferences.setString(AppConstant.keyRefreshToken, auth.refreshToken!);


    //verificar quis contas o usuario tem acesso
    List<Map<String, dynamic>> jsonList =
    await ApiUserList.getSchema(); // Obtenha a lista de contas

    //retornar se a lista de contas for vazia
    if (jsonList.isEmpty) {
      NotificationUtils.showError(context, 'Você não tem acesso a nenhuma conta');
      return;
    }
    List<Account> accounts = jsonList.map((json) => Account.fromJson(json)).toList();

    _accountList = accounts; // Armazene a lista de contas no provider

    //se o usuario tiver acesso a apenas uma conta, seleciona-la automaticamente
    if (_accountList.length == 1) {
      ListAccountProvider listAccountProvider = Provider.of<ListAccountProvider>(context, listen: false);
      _preferences.setBool('keyMultiConta', false);

      progressDialog.dismiss();

      listAccountProvider.setSchema(
          tenantId: _accountList[0].tenantId,
          personId: _accountList[0].personId,
          nameAccount: _accountList[0].nameConta,
          context: context
      );
      notifyListeners(); // Notifique os ouvintes sobre a atualização
    }
    else {
      _preferences.setBool('keyMultiConta', true);

      progressDialog.dismiss();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const ListAccountPage();
            },
          ),
              (Route<dynamic> route) => false,
        );

    }
    notifyListeners(); // Notifique os ouvintes sobre a atualização

  }

  UsersMe getMe() {
    UsersMe user = UsersMe.fromJwtToken(_token!);
    return user;
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
      if (kDebugMode) {
        print("Erro ao atualizar os dados: $error");
      }

      //NotificationUtils.showError('Erro ao atualizar os dados');
      throw error;
    }
  }


  Future<PersonMe> getDadosPessoais(BuildContext context) async {
    try {
      // Verifique se o token ainda é válido
      if (await isTokenValid()) {
        // Token válido, obtenha os dados pessoais
        PersonMe personMe = await ApiMe.getMe();
        notifyListeners();
        return personMe;
      } else {
        // Token não é válido, faça o refresh do token
        await refreshTokenConsulta(context);

        // Após o refresh, tente novamente obter os dados pessoais
        PersonMe refreshedPersonMe = await ApiMe.getMe();
        notifyListeners();
        return refreshedPersonMe;
      }
    } catch (error) {
      NotificationUtils.showWarning(context, 'Verifique sua conexão com a internet');
      throw Exception('Erro ao obter os dados pessoais');
    }
  }

  Future<void> refreshTokenConsulta(context) async {
    // Obtenha o refreshToken do SharedPreferences
    String? refreshToken = _preferences.getString(AppConstant.keyRefreshToken);
    String? token = _preferences.getString(AppConstant.keyToken);

    // Verifique se há refreshToken disponível
    if (refreshToken == null) {
      // Tratar a ausência de refreshToken (por exemplo, solicitar login novamente)
      return;
    }

    try {
      // Faça uma solicitação para renovar o token usando o refreshToken
      TokenModal response = await ApiClient.refreshToken(refreshToken: refreshToken, token: token);

      if (response.statusCode == 200) {
        _token = response.token;
        _refreshToken = response.refreshToken;
        await _preferences.setString(AppConstant.keyToken, response.token!);
        await _preferences.setString(AppConstant.keyRefreshToken, response.refreshToken!);
        notifyListeners();
      } else {
        //faça o logout
        logout();
        //ir para a tela de login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const LoginPage();
            },
          ),
              (Route<dynamic> route) => false,
        );
        // Tratar o erro na renovação do token (por exemplo, solicitar login novamente)
        NotificationUtils.showWarning(context, 'Sua sessão expirou, faça o login novamente');
        throw Exception('Erro ao renovar o token');
      }
    } catch (error) {
      NotificationUtils.showError(context, 'Verifique sua conexão de internet!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const LoginPage();
          },
        ),
            (Route<dynamic> route) => false,
      );
      throw Exception('Erro ao obter os dados pessoais');
    }
  }


  Future<void> logout() async {
    String? tokenNotification = _preferences.getString(AppConstant.tokenNotification);

    String? token = _preferences.getString(AppConstant.keyToken);
    //remover o token no servidor
    await ApiClient.logout(token: token!);
    //
    if (tokenNotification != null) {
      String? tokenFirebase = await FirebaseMessaging.instance.getToken();
      await ApiMe.removeToken(appId: tokenFirebase!);
    }
    //remover o token do shared preferences
    await _preferences.remove(AppConstant.keyToken);
    await _preferences.remove(AppConstant.keyUserInstance);
    await _preferences.remove(AppConstant.keyDadosPessoais);
    await _preferences.remove(AppConstant.keyPermission);
    await _preferences.remove(AppConstant.keyRefreshToken);

    await _preferences.remove(AppConstant.keyPersonId);
    await _preferences.remove(AppConstant.keyNameConta);
    await _preferences.remove(AppConstant.keyUserInstance);
    _preferences.remove('_token');
    await _preferences.remove(AppConstant.tokenNotification);
    await _preferences.remove('keyMultiConta');
    return;
  }

  Future<bool> isTokenValid() {
    // Obtenha o token do SharedPreferences
    String? token = _preferences.getString(AppConstant.keyToken);
    // Verifique se há token disponível
    if (token == null) {
      return Future.value(false);
    }

    try {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

    // Verifique o tempo de uso do token (1 hora neste exemplo)
    DateTime issuedAt = DateTime.fromMillisecondsSinceEpoch(decodedToken['iat'] * 1000);
    DateTime now = DateTime.now();
    Duration tokenUsageDuration = now.difference(issuedAt);

        if (tokenUsageDuration.inHours >= 6) {
          // O token foi usado por mais de 6 hora, renove o token
          return Future.value(false);
          } else {
          // O token é válido
          return Future.value(true);
        }
    } catch (error) {
      // Tratar o erro na validação do token
      return Future.value(false);
    }
  }

  void keyIsFirstLogin(bool bool) {
    _preferences.setBool('keyIsFirstLogin', bool);
  }
}
