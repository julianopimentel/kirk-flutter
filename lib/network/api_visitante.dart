
import 'dart:convert';

import 'package:KirkDigital/model/visitante.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';

class ApiVisitante{
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      responseType: ResponseType.plain,
      validateStatus: (int? code) {
        return true;
      },
    ),
  );

  static Future<List<Visitor>> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInstance = prefs.getString(AppConstant.keyUserInstance);
    String? token = prefs.getString('token');

    Response<String> apiResponse = await _dio.get<String>(
      '/v1/visitor/all', // Substitua pelo endpoint correto da API
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
          'user_instance': userInstance!,
        },
      ),
    );

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      List<Visitor> visitors = (json.decode(apiResponse.data!) as List)
          .map((data) => Visitor.fromJson(data))
          .toList();

      return visitors;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao buscar a lista de visitantes');
    }
  }


  static Future<Visitor> createVisitor(Visitor visitor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInstance = prefs.getString(AppConstant.keyUserInstance);
    String? token = prefs.getString('token');

    final Map<String, dynamic> visitorData = visitor.toJson();

    Response<String> apiResponse = await _dio.post<String>(
      '/v1/visitor', // Substitua pelo endpoint correto da API
      data: visitorData,
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
          'user_instance': userInstance!,
        },
      ),
    );

    return Visitor.fromJson(json.decode(apiResponse.data ?? '{}'));
  }

  static Future<void> deleteVisitor(int visitorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInstance = prefs.getString(AppConstant.keyUserInstance);
    String? token = prefs.getString('token');

    Response<String> apiResponse = await _dio.delete<String>(
      '/v1/visitor/$visitorId', // Substitua pelo endpoint correto da API com o ID do visitante
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
          'user_instance': userInstance!,
        },
      ),
    );

    // Você pode verificar o código de status da resposta aqui
    if (apiResponse.statusCode == 204) {
      // O visitante foi excluído com sucesso
      return;
    } else {
      // Lidar com erros, como visitante não encontrado, aqui
      throw Exception('Erro ao excluir o visitante');
    }
  }

}