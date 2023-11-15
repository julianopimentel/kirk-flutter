import 'package:dio/dio.dart';

import '../dio_service.dart';
import 'app_theme.dart';

class ApiSkinData {
  static Future<SkinData> getSkinId(int id) async {
    Dio dioInstance = DioService.dioInstance;
    Response apiResponse = await dioInstance.get('/public/skin/$id');

    return SkinData.fromJson(apiResponse.data ?? '{}');
  }
}