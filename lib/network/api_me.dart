import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/person_me.dart';

class ApiMe {
  static Future<Dio> createDioInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInstance = prefs.getString(AppConstant.keyUserInstance);
    String? token = prefs.getString(AppConstant.keyToken);

    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        responseType: ResponseType.plain,
        validateStatus: (int? code) {
          return true;
        },
        headers: {
          'authorization': 'Bearer $token',
          'user_instance': userInstance!,
        },
      ),
    );

    return dio;
  }

  static Future<PersonMe> getMe() async {
    Dio dioInstance = await createDioInstance();
    Response apiResponse = await dioInstance.get('/v1/person/me');

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      PersonMe person = PersonMe.fromJson(apiResponse.data!);

      return person;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao buscar os dados do usuário');
    }
  }

  static Future<void> postMe({
    required String name,
    required String phone,
    required String image,
  }) async {
    Dio dioInstance = await createDioInstance();
    Response apiResponse = await dioInstance.put(
      '/v1/person/me',
      data: {
        'name': name,
        'phone': phone,
        'image': image,
      },
    );

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      return apiResponse.data;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao atualizar os dados do usuário');
    }
  }

  static Future<void> saveTokenNotification({required String app_id}) async {

    String? platform = await getPlatform();
    Dio dioInstance = await createDioInstance();
    Response apiResponse = await dioInstance.put(
      '/v1/app/notification',
      data: {
        'app_id': app_id,
        'platform': platform,
      },
    );

    if (apiResponse.statusCode == 202) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      return apiResponse.data;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao salvar o token de notificação');
    }
  }

  //metodo para retornar qual a plataforma do dispositivo
  static Future<String?> getPlatform() async {
    String? platform;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        platform = 'ANDROID';
        break;
      case TargetPlatform.iOS:
        platform = 'IOS';
        break;
      case TargetPlatform.macOS:
        platform = 'MACOS';
        break;
      case TargetPlatform.windows:
        platform = 'WINDOWS';
        break;
      case TargetPlatform.linux:
        platform = 'LINUX';
        break;
      default:
        null;
    }
    return platform;
  }

  static Future<void> removeToken({
    required String app_id}) async {

    String? platform = await getPlatform();

    Dio dioInstance = await createDioInstance();
    Response apiResponse = await dioInstance.delete(
      '/v1/app/notification',
      data: {
        'app_id': app_id,
        'platform': platform,
      },
    );

   return apiResponse.data;
  }
}
