import 'dart:convert';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;

  TokenManager._internal();

  String? _token;
  String? _user_instance;
  String? _person_id;
  String? _name_conta;

  String? get token => _token;
  String? get user_instance => _user_instance;
  String? get person_id => _person_id;
  String? get name_conta => _name_conta;

  void setTokenFromJson(String jsonToken) {
    try {
      final Map<String, dynamic> tokenMap = json.decode(jsonToken);
      final String tokenValue = tokenMap['token'] as String;
      if (tokenValue.startsWith('Bearer ')) {
        _token = tokenValue.substring(7); // Remove 'Bearer ' prefix, if present
      } else {
        _token = tokenValue;
      }
    } catch (e) {
      print("Erro ao decodificar o token JSON: $e");
    }
  }

  String? getToken() {
    return _token;
  }

  String? getUserInstance() {
    return _user_instance;
  }

  //set person_id e name_conta
  void setSchema(String person_id, String name_conta) {
    _person_id = person_id;
    _name_conta = name_conta;
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

  void removeSchema() {
    _person_id = null;
    _name_conta = null;
  }
}
