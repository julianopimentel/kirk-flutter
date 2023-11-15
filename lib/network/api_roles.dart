
import 'dart:convert';

import 'package:dio/dio.dart';
import '../model/roles.dart';
import '../service/dio_service.dart';

class ApiRoles{
  static Future<List<RolesDto>> getList() async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.get('/v1/roles');

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      List<RolesDto> data = (json.decode(apiResponse.data!) as List)
          .map((data) => RolesDto.fromJson(data))
          .toList();

      return data;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao buscar a lista de visitantes');
    }
  }

}