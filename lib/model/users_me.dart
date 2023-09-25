import 'dart:convert';

class UsersMe {
  UsersMe({
    this.code,
    this.message,
    this.data,
    required this.userId,
    this.name,
    this.email,
    this.roles,
    this.image,
    this.phone,
  });

  String? code;
  String? message;
  Data? data;
  int userId;
  String? name;
  String? email;
  String? roles;
  String? image;
  String? phone;

  factory UsersMe.fromJson(String str) {
    return UsersMe.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory UsersMe.fromMap(Map<String, dynamic> json) {
    return UsersMe(
      code: json["code"],
      message: json["message"],
      data: Data.fromMap(json["data"] ?? {}),
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
      roles: json["roles"],
      image: json["image"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "code": code,
      "message": message,
      "data": data?.toMap(),
      "userId": userId,
      "name": name,
      "email": email,
      "roles": roles,
      "image": image,
      "phone": phone,
    };
  }

  // Função para gerar o token JWT
  static UsersMe fromJwtToken(String token) {
    final jwtParts = token.split('.');
    final jwtPayload = jwtParts[1];
    final Map<String, dynamic> decodedPayload =
    jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(jwtPayload))));
    return UsersMe.fromMap(decodedPayload);
  }

  @override
  String toString() {
    JsonEncoder encoder = const JsonEncoder.withIndent('    ');
    return encoder.convert(toMap());
  }

  int getUserId() {
    return userId;
  }

}

class Data {
  Data({
    this.status,
  });

  int? status;

  factory Data.fromJson(String str) {
    return Data.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Data.fromMap(Map<String, dynamic> json) {
    return Data(
      status: json["status"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "status": status,
    };
  }
}

class Links {
  Links({
    this.self,
    this.collection,
  });

  List<Collection>? self;
  List<Collection>? collection;

  factory Links.fromJson(String str) {
    return Links.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Links.fromMap(Map<String, dynamic> json) {
    return Links(
      self: List<Collection>.from(
        json["self"]?.map((x) => Collection.fromMap(x)) ?? [],
      ),
      collection: List<Collection>.from(
        json["collection"]?.map((x) => Collection.fromMap(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "self": List<dynamic>.from(
        self?.map((x) => x.toMap()) ?? [],
      ),
      "collection": List<dynamic>.from(
        collection?.map((x) => x.toMap()) ?? [],
      ),
    };
  }
}

class Collection {
  Collection({
    this.href,
  });

  String? href;

  factory Collection.fromJson(String str) {
    return Collection.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Collection.fromMap(Map<String, dynamic> json) {
    return Collection(
      href: json["href"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "href": href,
    };
  }
}