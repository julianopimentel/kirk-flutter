
class RolesDto {
  late final int? id;
  late final String? name;

  RolesDto({
    this.id,
    this.name
  });

  // Implemente o método toJson para converter Visitor em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  // Implemente o método factory para criar um objeto Visitor a partir de um mapa JSON
  factory RolesDto.fromJson(Map<String, dynamic> json) {
    return RolesDto(
      id: json['id'],
      name: json['name']
    );
  }
}
