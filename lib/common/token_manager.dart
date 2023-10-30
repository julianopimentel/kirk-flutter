import 'dart:convert';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;

  TokenManager._internal();
  
  String? _user_instance;
  String? get user_instance => _user_instance;

  String? getUserInstance() {
    return _user_instance;
  }

  void setUserInstance(String jsonUserInstance) {
    try {
      final Map<String, dynamic> userInstanceMap = json.decode(jsonUserInstance);
      final String userInstanceValue = userInstanceMap['body']['user_instance'] as String;
        _user_instance = userInstanceValue;
    } catch (e) {
      print("Erro ao decodificar o token JSON: $e");
    }
  }
  }
