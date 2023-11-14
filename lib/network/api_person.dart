
import 'dart:convert';

import 'package:KirkDigital/model/person.dart';
import 'package:KirkDigital/model/SimplesPessoaDto.dart';

import 'package:dio/dio.dart';

import '../service/dio_service.dart';

class ApiPerson{
  static Future<List<SimplesPessoaDto>> getList() async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.get('/v1/person/foto');

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      List<SimplesPessoaDto> persons = (json.decode(apiResponse.data!) as List)
          .map((data) => SimplesPessoaDto.fromJson(data))
          .toList();

      return persons;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao buscar a lista de visitantes');
    }
  }

  static Future<Pessoa> create(Pessoa pessoa) async {
    Dio dioInstance = DioService.dioInstance;
    print('pessoa: ${pessoa.toJson()}');

    Response apiResponse = await dioInstance.post(
      '/v1/person',
      data: jsonEncode(pessoa),
    );

    return Pessoa.fromJsonComRoles(jsonDecode(apiResponse.data));
  }


  static Future<Pessoa> getById(int id) async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.get('/v1/person/$id');

    return Pessoa.fromJsonComRoles(jsonDecode(apiResponse.data));
  }


  static Future<Pessoa> update(Pessoa pessoa) async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.put(
      '/v1/person/${pessoa.id}',
      data: jsonEncode(pessoa),
    );

    return Pessoa.fromJson(jsonDecode(apiResponse.data));
  }

  static Future<void> delete(int id) async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.delete('/v1/person/$id');

    if (apiResponse.statusCode != 200) {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao excluir o visitante');
    }
  }

}