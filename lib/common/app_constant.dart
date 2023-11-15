class AppConstant {
  // URL base
  static const String testBaseUrl = 'http://192.168.1.206:8080/api'; // URL de teste
  static const String productionBaseUrl = 'https://kirkapi.onrender.com/api'; // URL de produção

  // Tokens
  static const String keyToken = 'token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserInstance = 'user_instance';

  //usuario e conta
  static const String keyPermission = 'permission';
  static const bool keyMultiAccount = false;  //usuario tem mais de uma conta?
  static const String keyDadosPessoais = 'dados_pessoais';
  static const String tokenNotification = 'token_notification';
  static const String keyPersonId = 'person_id';
  static const String keyNameConta = 'name_conta';
  static const String keyTenantId = 'tenant_id';

  //customização
  static const String keyCor= 'cor';
  static const String keyIntegrador = 'integrador';
  static const String keyLogo = 'logo';
  static const String keyLogoMenu = 'logoMenu';

  //lgin
  static const String keyIsFirstLogin = 'keyIsFirstLogin';



  static String get baseUrl {
    // Verifique o ambiente de execução e retorne a URL apropriada
    if (isInTestMode) {
      return testBaseUrl;
    } else {
      return productionBaseUrl;
    }
  }
  // Variável que define o ambiente de execução (teste ou produção)
  static bool get isInTestMode {
    // Retorne true para ambiente de teste e false para ambiente de produção.
    return true; // Defina a lógica apropriada aqui.
  }

  String get getbaseUrl {
    return baseUrl;
  }


}
