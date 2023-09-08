class Pessoa {
  final int? id;
  final String? name;
  final String? email;
  final String? roles;
  final String? image;
  final String? phone;
  final List<int>? birthAt; // Declare como uma lista de inteiros
  final String? sex;
  final bool? createAccess;
  final int? rolesId;

  Pessoa({
    this.id,
    this.name,
    this.email,
    this.roles,
    this.image,
    this.phone,
    this.sex,
    this.birthAt,
    this.createAccess,
    this.rolesId,
  });

  // Implemente o método toJson para converter Visitor em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'phone': phone,
      'image': image,
      'sex' : sex,
      'birthAt' : birthAt,
      'createAccess' : createAccess,
    };
  }

  // Implemente o método factory para criar um objeto Visitor a partir de um mapa JSON
  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      roles: json['roles'],
      image: json['image'],
      birthAt: json['birthAt'] != null
          ? List<int>.from(json['birthAt']) // Converta para uma lista de inteiros
          : null, // Certifique-se de lidar com valores nulos
      sex: json['sex'],
      createAccess: json['createAccess'],
    );
  }

  factory Pessoa.fromJsonComRoles(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      roles: json['roles'] != null ? json['roles']['name'] : null,
      rolesId: json['roles'] != null ? json['roles']['id'] : null,
      image: json['image'],
      birthAt: json['birthAt'] != null
          ? List<int>.from(json['birthAt']) // Converta para uma lista de inteiros
          : null, // Certifique-se de lidar com valores nulos
      sex: json['sex'],
      createAccess: json['createAccess'],
    );
  }
}
