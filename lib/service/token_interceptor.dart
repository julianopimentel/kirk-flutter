import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_constant.dart';
import '../model/auth_token.dart';
import '../network/api_client.dart';

class TokenInterceptor extends Interceptor {
  late final SharedPreferences _preferences;

  TokenInterceptor() {
    SharedPreferences.getInstance().then((value) => _preferences = value);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Obtém o token ou dados adicionais do usuário do seu serviço
    final userInstance = _preferences.getString(AppConstant.keyUserInstance);
    final token = _preferences.getString(AppConstant.keyToken);

    try {
      // Verifique se o token ainda é válido
      if (await isTokenValid()) {
        if (userInstance != null) {
          options.headers['user_instance'] = userInstance;
        }

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } else {
        // O token não é mais válido, solicite um novo token
        refreshTokenApi();
      }
    } catch (error) {
      // Tratar o erro na validação do token
      print(error);
    }

    // Continue com a solicitação
    handler.next(options);
  }

  Future<bool> isTokenValid() async {
    // Obtenha o token do SharedPreferences
    String? token = _preferences.getString(AppConstant.keyToken);

    // Verifique se há token disponível
    if (token == null) {
      return false;
    }

    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

      // Verifique o tempo de uso do token (5 horas neste exemplo)
      DateTime issuedAt = DateTime.fromMillisecondsSinceEpoch(decodedToken['iat'] * 1000);
      DateTime now = DateTime.now();
      Duration tokenUsageDuration = now.difference(issuedAt);

      if (tokenUsageDuration.inHours >= 20) {
        // O token é válido, mas vai renovar a cada 20 horas
        return true;
      } else {
        // O token expirou ou nao existe
        return true;
      }
    } catch (error) {
      // Tratar o erro na validação do token
      return false;
    }
  }

  void refreshTokenApi() async {
    // Obtenha o refreshToken do SharedPreferences
    String? refreshToken = _preferences.getString(AppConstant.keyRefreshToken);
    String? token = _preferences.getString(AppConstant.keyToken);

    // Verifique se há refreshToken disponível
    if (refreshToken == null) {
      // Tratar a ausência de refreshToken (por exemplo, solicitar login novamente)
      return;
    }

    try {
      // Faça uma solicitação para renovar o token usando o refreshToken
      TokenModal response = await ApiClient.refreshToken(refreshToken: refreshToken, token: token);

      if (response.statusCode == 200) {
        _preferences.setString(AppConstant.keyToken, response.token!);
        _preferences.setString(AppConstant.keyRefreshToken, response.refreshToken!);
      } else {
        // Tratar o erro na renovação do token
      }
    } catch (error) {
      // Tratar o erro na renovação do token
    }
  }
}
