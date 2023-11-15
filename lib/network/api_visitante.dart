
import 'dart:convert';

import 'package:dio/dio.dart';

import '../model/visitante.dart';
import '../service/dio_service.dart';

class ApiVisitante{
  static Future<List<Visitor>> getList() async {
    Dio dioInstance = DioService.dioInstance;

    Response<String> apiResponse = await dioInstance.get<String>(
      '/v1/visitor/all',
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
    Dio dioInstance = DioService.dioInstance;
    final Map<String, dynamic> visitorData = visitor.toJson();

    Response<String> apiResponse = await dioInstance.post<String>(
      '/v1/visitor', // Substitua pelo endpoint correto da API
      data: visitorData,
    );

    return Visitor.fromJson(json.decode(apiResponse.data ?? '{}'));
  }

  static Future<void> deleteVisitor(int visitorId) async {
    Dio dioInstance = DioService.dioInstance;
    Response<String> apiResponse = await dioInstance.delete<String>(
      '/v1/visitor/$visitorId', // Substitua pelo endpoint correto da API com o ID do visitante
    );

    if(apiResponse.statusCode != 200){
      throw Exception('Erro ao excluir o visitante');
    }

  }

}