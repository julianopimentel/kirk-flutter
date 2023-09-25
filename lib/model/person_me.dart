
import 'dart:convert';

class PersonMe {
  final int? id;
  final String? name;
  final String? email;
  final String? roles;
  final String? image;
  final String? phone;
  final String? sex;
  final int? rolesId;

  PersonMe({
    this.id,
    this.name,
    this.email,
    this.roles,
    this.image,
    this.phone,
    this.sex,
    this.rolesId,
  });

  factory PersonMe.fromJson(String str) {
    return PersonMe.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory PersonMe.fromMap(Map<String, dynamic> json) {
    return PersonMe(
      name: json["name"],
      email: json["email"],
      roles: json["roles"],
      image: json["image"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "email": email,
      "roles": roles,
      "image": image,
      "phone": phone,
    };
  }
}