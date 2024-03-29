import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/person_me.dart';
import '../network/api_me.dart';
import '../utils/firebase/firebase_options.dart';
import '../model/user_list.dart'; // Importe a classe Account
import '../model/users_me.dart';
import '../network/api_user_list.dart';
import '../ui/home/home.dart';
import '../common/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';

class ListAccountProvider with ChangeNotifier {
  List<Account> _accountList = []; // Lista de contas
  List<Account> get accountList => _accountList;

  Future<void> init() async {}

  Future<void> getSchema(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      List<Map<String, dynamic>> jsonList =
          await ApiUserList.getSchema(); // Obtenha a lista de contas

      List<Account> accounts =
          jsonList.map((json) => Account.fromJson(json)).toList();

      _accountList = accounts; // Armazene a lista de contas no provider

      //possui mais de uma conta?
      if (accounts.length > 1) {
        //salvar o tenantId e personId no shared_preferences
        prefs.setBool('keyMultiConta', true);
      } else {
        //salvar o tenantId e personId no shared_preferences
        prefs.setBool('keyMultiConta', false);
      }
      notifyListeners(); // Notifique os ouvintes sobre a atualização
    } catch (error) {
      // Trate os erros, se necessário
      if (kDebugMode) {
        print("Erro ao buscar os dados: $error");
      }
    }
  }

  Future<void> setSchema({
    required int tenantId,
    required int personId,
    required String nameAccount,
    required BuildContext context
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(AppConstant.keyToken);
    //deixar a permissão vazia
    //pegar o UserId
    UsersMe user = UsersMe.fromJwtToken(token!);
    int userId = user.getUserId();

    try {
      await ApiUserList.setSchema(
        userId: userId.toInt(),
        tenantId: tenantId,
        personId: personId,
      ); // Obtenha a lista de contas

      //salvar o tenantId e personId no shared_preferences
      prefs.setInt(AppConstant.keyTenantId, tenantId);
      prefs.setInt(AppConstant.keyPersonId, personId);
      prefs.setString(AppConstant.keyNameConta, nameAccount);

      //consultar os dados pessoais
      PersonMe personMe = await ApiMe.getMe();
      //salvar os dados pessoais no shared_preferences
      prefs.setString(AppConstant.keyDadosPessoais, personMe.toJson().toString());

      //salvar o token_notification no shared_preferences
      setupToken();

      notifyListeners(); // Notifique os ouvintes sobre a atualização
      // Redirecione para a tela inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Substitua HomePage pelo nome da sua tela inicial
      );


    } catch (error) {
      //remover o name_conta e persoId
      prefs.remove(AppConstant.keyTenantId);
      prefs.remove(AppConstant.keyPersonId);
      prefs.remove(AppConstant.keyNameConta);
      // Trate os erros, se necessário
      if (kDebugMode) {
        print("Erro ao buscar os dados: $error");
      }
      //NotificationUtils.showError('Erro ao selecionar a conta!');
    }
  }

  Future<void> setupToken() async {
    Stream<String> tokenStream;
    requestNotificationPermission(); // Solicitar permissão de notificação ao iniciar o aplicativo.

    try {
      FirebaseApp app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        print('Initialized default app $app');
      }

      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();

      tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      tokenStream.listen((token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppConstant.tokenNotification, token);
      });

      saveTokenToDatabase(token!);
    } catch (e) {
      if (kDebugMode) {
        print('Erro na inicialização do Firebase: $e');
      }
    }
  }


  Future<void> requestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      if (kDebugMode) {
        print('Permissão de notificação concedida');
      }
    } else {
      if (kDebugMode) {
        print('Permissão de notificação negada');
      }
      // Você pode mostrar uma mensagem ao usuário para informar sobre a importância da permissão.
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    //identificar o tipo de plataforma
    await ApiMe.saveTokenNotification(appId: token);
    if (kDebugMode) {
      print('Token salvo no banco de dados $token');
    }
  }
}
