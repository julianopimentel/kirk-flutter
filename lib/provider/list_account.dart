import 'package:KirkDigital/common/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/token_manager.dart';
import '../model/user_list.dart'; // Importe a classe Account
import '../model/users_me.dart';
import '../network/api_UserList.dart';
import '../service/notification_service.dart';
import '../ui/home.dart';

class ListAccountProvider with ChangeNotifier {
  String? _token;
  late final SharedPreferences _preferences;
  List<Account> _accountList = []; // Lista de contas

  List<Account> get accountList => _accountList;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = TokenManager().getToken();
  }

  Future<void> getSchema() async {

    try {
      List<Map<String, dynamic>> jsonList =
          await ApiUserList.getSchema(); // Obtenha a lista de contas

      List<Account> accounts =
          jsonList.map((json) => Account.fromJson(json)).toList();

      _accountList = accounts; // Armazene a lista de contas no provider

      notifyListeners(); // Notifique os ouvintes sobre a atualização

      //possui mais de uma conta?
      if (accounts.length > 1) {
        //salvar o tenantId e personId no shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('keyMultiConta', true);
      }
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
    }
  }

  Future<void> setSchema({
    required String tenantId,
    required String personId,
    required String name_conta,
    required BuildContext context
  }) async {
    TokenManager().setSchema(personId, name_conta);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    //deixar a permissão vazia
    //pegar o UserId
    UsersMe user = UsersMe.fromJwtToken(token!);
    int? userId = user.getUserId();

    try {
      await ApiUserList.setSchema(
        userId: userId.toString(),
        tenantId: tenantId,
        personId: personId,
      ); // Obtenha a lista de contas

      //salvar o tenantId e personId no shared_preferences
      prefs.setString('tenantId', tenantId);
      prefs.setString('personId', personId);
      prefs.setString('name_conta', name_conta);

      notifyListeners(); // Notifique os ouvintes sobre a atualização

      // Redirecione para a tela inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Substitua HomePage pelo nome da sua tela inicial
      );


    } catch (error) {
      //remover o name_conta e persoId
      TokenManager().removeSchema();
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
      NotificationService.showNotification('Erro ao selecionar a conta!', NotificationType.error, context);
    }
  }
}
