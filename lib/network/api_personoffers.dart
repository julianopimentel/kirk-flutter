
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/personoffers.dart';
import '../service/DioService.dart';

class ApiPersonOffers {
  static Future<List<PessoaOffer>> getList(int page, int size) async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.get('/v1/person/offers/my-offers?page=$page&Size=$size');

    if (apiResponse.statusCode == 200) {
      // Verifique se a resposta da API foi bem-sucedida (código 200)
      List<PessoaOffer> dados = (json.decode(apiResponse.data!) as List)
          .map((data) => PessoaOffer.fromJson(data))
          .toList();

      return dados;
    } else {
      // Lidar com erros de resposta da API, se necessário
      throw Exception('Erro ao buscar a lista de visitantes');
    }
  }

}