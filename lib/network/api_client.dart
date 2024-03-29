import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../common/app_constant.dart';
import '../model/auth_token.dart';
import '../model/users_me.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      responseType: ResponseType.plain,
      validateStatus: (int? code) {
        return true;
      },
    ),
  );

  static Future<AuthToken> login({
    required String email,
    required String password,
  }) async {

    if (kDebugMode) {
      print('Destino API:${AppConstant.baseUrl}');
    }
    Response<String> response = await _dio.post<String>(
      '/auth/signin',
      //dados dentro do body
      data: <String, String>{
        'email': email,
        'password': password,
      },
    );

    try {
      return AuthToken.fromJson(response.data ?? '{}');
    } catch (e) {
      rethrow;
    }

  }


  Future<UsersMe> getMe() async {
    String token = AppConstant.keyToken;
    Response<String> response = await _dio.get(
      '/auth/user',
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
        },
      ),
    );
    return UsersMe.fromJson(response.data ?? '{}');
  }

  static register({required String name, required String email, required String password}) async {
    Response<String> response = await _dio.post<String>(
      '/auth/signup',
      data: <String, String>{
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return AuthToken.fromJson(response.data ?? '{}');
  }

  static Future<TokenModal> refreshToken({required String refreshToken, String? token}) async {
    Response<String> response = await _dio.post<String>(
      '/auth/refreshtoken',
      data: <String, String>{
        'refreshToken': refreshToken,
      },
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
        },
      ),
    );
    return TokenModal.fromJson(response.data ?? '{}');
  }

  static Future<void> logout({
    required String token}) async {
    Response apiResponse = await _dio.post<String>(
      '/auth/signout',
      options: Options(
        headers: <String, String>{
          'authorization': 'Bearer $token',
        },
      ),
    );
    return apiResponse.data;
  }
}
