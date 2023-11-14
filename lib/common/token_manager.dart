import 'dart:convert';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;

  TokenManager._internal();
  
  String? _userInstance;
  String? get userInstance => _userInstance;

  String? getUserInstance() {
    return _userInstance;
  }

  void setUserInstance(String jsonUserInstance) {
    try {
      final Map<String, dynamic> userInstanceMap = json.decode(jsonUserInstance);
      final String userInstanceValue = userInstanceMap['body']['user_instance'] as String;
        _userInstance = userInstanceValue;
    } catch (e) {
      print("Erro ao decodificar o token JSON: $e");
    }
  }
  }
