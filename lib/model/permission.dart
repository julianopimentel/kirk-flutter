
class Permission {
  final int? id;
  final String? features;
  final bool? criar;
  final bool? ler;
  final bool? atualizar;
  final bool? excluir;

  Permission({
    this.id,
    this.features,
    this.criar,
    this.ler,
    this.atualizar,
    this.excluir,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      features: json['features'],
      criar: json['criar'],
      ler: json['ler'],
      atualizar: json['atualizar'],
      excluir: json['excluir'],
    );
  }

  static List<Permission> permissionsFromJson(List<dynamic> jsonList) {
    return jsonList.map((dynamic json) {
      if (json is Map<String, dynamic>) {
        return Permission.fromJson(json);
      } else {
        return Permission(); // Retorna um objeto vazio
      }
    }).toList();
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'features': features,
      'criar': criar,
      'ler': ler,
      'atualizar': atualizar,
      'excluir': excluir,
    };
  }
}
