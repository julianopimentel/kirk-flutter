class PessoaOffer {
  final int? id;
  final String? category;
  final String? price;
  final String? total;
  final String? type;
  final String? paymentMethod;
  final List<int>? dateLancamento; // Declare como uma lista de inteiros

  PessoaOffer({
    this.id,
    this.category,
    this.price,
    this.total,
    this.type,
    this.paymentMethod,
    this.dateLancamento,
  });

  // Implemente o método toJson para converter Visitor em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'price': price,
      'total': total,
      'type': type,
      'paymentMethod': paymentMethod,
      'dateLancamento': dateLancamento,
    };
  }

  // Implemente o método factory para criar um objeto Visitor a partir de um mapa JSON
  factory PessoaOffer.fromJson(Map<String, dynamic> json) {
    return PessoaOffer(
      id: json['id'],
      category: json['category'],
      price: json['price'],
      total: json['total'],
      type: json['type'],
      paymentMethod: json['paymentMethod'],
      dateLancamento: json['dateLancamento'] != null
          ? List<int>.from(json['dateLancamento']) // Converta para uma lista de inteiros
          : null, // Certifique-se de lidar com valores nulos
    );
  }

}
