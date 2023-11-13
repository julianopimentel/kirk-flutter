import 'dart:convert';

import 'package:KirkDigital/model/permission.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../common/token_manager.dart';
import '../model/auth_token.dart';
import '../service/DioService.dart';

class ApiUserList {
  //buscar lista com as contas do usuario
  static Future<List<Map<String, dynamic>>> getSchema() async {
    Dio dioInstance = DioService.dioInstance;
    Response<String> response = await dioInstance.get(
      '/v1/usertenant',
    );
    if(response.data == "") {
      return [];
    }

    List<dynamic> jsonData = json.decode(response.data ?? '{}');
    return jsonData.cast<Map<String, dynamic>>();
  }


  //setar a conta principal e receber o user_instance
  static Future<AuthToken> setSchema({required int userId, required int tenantId, required int personId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dioInstance = DioService.dioInstance;
    //setar a conta principal
    Response<String> response = await dioInstance.post<String>(
      '/v1/usertenant/enter',
      data: <String, int>{
        'userId': userId,
        'tenantId': tenantId,
        'personId': personId,
      },
    );
    //salvar o user_instance no shared_preferences
    TokenManager().setUserInstance(response.data ?? '{}');
    String userInstance = TokenManager().getUserInstance() ?? '';
    prefs.setString(AppConstant.keyUserInstance, userInstance);

    //buscar as permissoes do usuario
    // Fazer a solicitação da API e processar os dados
    try {
      Response<String> responseData = await dioInstance.get<String>(
        '/v1/permission',
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Verifique se a resposta da API não está vazia
      if (responseData.data != null && responseData.statusCode != 500) {
        dynamic jsonData = json.decode(responseData.data ?? '{}');

        // Converte a resposta JSON em uma lista de mapas
        List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(jsonData);

        // Converte a lista de mapas em uma lista de objetos Permission
        List<Permission> permissions = jsonList
            .map((json) => Permission.fromJson(json))
            .toList();

        // Salva as permissões no SharedPreferences
        prefs.setString(
          AppConstant.keyPermission,
          json.encode(permissions.map((p) => p.toJson()).toList()),
        );
      } else {
        //limpar a permissão

        prefs.setString(AppConstant.keyPermission, '');
        // Trate o caso em que a resposta da API está vazia
        print('Resposta da API está vazia');
      }
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao buscar as permissões: $error");
    }
    return AuthToken.fromJsonTokenUser(response.data ?? '{}');
  }
}
