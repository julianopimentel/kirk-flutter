import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/person_me.dart';

class ApiMe {
  static Future<Dio> createDioInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInstance = prefs.getString(AppConstant.keyUserInstance);
    String? token = prefs.getString('token');

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

}
