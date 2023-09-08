class Visitor {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final List<int>? birthAt; // Declare como uma lista de inteiros
  final String? aniversario;
  final String? sex;

  Visitor({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.birthAt,
    this.sex,
    this.aniversario,
  });

  // Implemente o método toJson para converter Visitor em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birthAt': birthAt,
      'sex':sex,
      'aniversario':aniversario,
    };
  }

  // Implemente o método factory para criar um objeto Visitor a partir de um mapa JSON
  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthAt: json['birthAt'] != null
          ? List<int>.from(json['birthAt']) // Converta para uma lista de inteiros
          : null, // Certifique-se de lidar com valores nulos
      sex: json['sex'],
      aniversario: json['aniversario'],
    );
  }
}
