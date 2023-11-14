import 'dart:convert';

class AuthToken {
  AuthToken({
    this.code,
    this.message,
    this.data,
    this.token,
    this.refreshToken,
    this.tokenType,
    this.userEmail,
    this.userId,
    this.userInstance,
    this.userRole,
  });

  String? code;
  String? message;
  Data? data;
  String? token;
  String? refreshToken;
  String? tokenType;
  String? userEmail;
  int? userId;
  String? userName;
  String? userInstance;
  List<String>? userRole;

  //login normal
  factory AuthToken.fromJson(String str) => AuthToken.fromMap(json.decode(str));
  //token e user_instance
  factory AuthToken.fromJsonTokenUser(String str) => AuthToken.fromTokenUserMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthToken.fromMap(Map<String, dynamic> json) => AuthToken(
    code: json["code"],
    message: json["message"],
    data: Data.fromMap(json["data"] ?? {}),
    token: json["accessToken"],
    refreshToken: json["refreshToken"],
    tokenType: json["tokenType"],
    userId: json["id"],
    userEmail: json["email"],
    userInstance: json["user_instance"],
  );

  factory AuthToken.fromTokenUserMap(Map<String, dynamic> json) => AuthToken(
    code: json["code"],
    message: json["message"],
    data: Data.fromMap(json["data"] ?? {}),
    userInstance: json["user_instance"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data?.toMap(),
    "accessToken": token,
    "refreshToken": refreshToken,
    "tokenType": tokenType,
    "id": userId,
    "email": userEmail,
    "user_instance": userInstance,
  };
  @override
  String toString() {
    JsonEncoder encoder = const JsonEncoder.withIndent('    ');
    return encoder.convert(toMap());
  }
}

class Data {
  Data({
    this.status,
  });

  int? status;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
  };
}

//class simples do refresh token e token
class TokenModal {
  TokenModal({
    this.statusCode,
    this.message,
    this.data,
    this.token,
    this.refreshToken,
  });

  String? token;
  String? refreshToken;
  int? statusCode;
  String? message;
  Data? data;

  factory TokenModal.fromJson(String str) => TokenModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TokenModal.fromMap(Map<String, dynamic> json) => TokenModal(
    token: json["accessToken"],
    refreshToken: json["refreshToken"],
    statusCode: json["statusCode"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "accessToken": token,
    "refreshToken": refreshToken,
    "statusCode": statusCode,
    "message": message,
  };
}