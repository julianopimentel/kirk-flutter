import 'package:KirkDigital/service/token_interceptor.dart';
import 'package:dio/dio.dart';

import '../common/app_constant.dart';

class DioService {
  static Dio? _dioInstance;

  static Dio get dioInstance {
    // Se a instância do Dio já existir, retorne-a
    if (_dioInstance != null) {
      return _dioInstance!;
    }

    // Se não existir, crie uma nova instância
    _dioInstance = _createDioInstance();
    return _dioInstance!;
  }

  static Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        responseType: ResponseType.plain,
        validateStatus: (int? code) {
          return true;
        },
      ),
    );

    // Adicione o interceptor
    dio.interceptors.add(TokenInterceptor());

    return dio;
  }
}
