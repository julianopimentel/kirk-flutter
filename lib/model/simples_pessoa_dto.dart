class SimplesPessoaDto {
  late final int? id;
  late final String? name;
  late final String? image;

  SimplesPessoaDto({
    this.id,
    this.name,
    this.image,
  });

  // Implemente o método toJson para converter Visitor em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  // Implemente o método factory para criar um objeto Visitor a partir de um mapa JSON
  factory SimplesPessoaDto.fromJson(Map<String, dynamic> json) {
    return SimplesPessoaDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
