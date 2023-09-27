
import 'dart:convert';

import 'package:KirkDigital/model/visitante.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/personoffers.dart';

class ApiPersonOffers {
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

  static Future<List<PessoaOffer>> getList(int page, int size) async {
    Dio dioInstance = await createDioInstance();
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