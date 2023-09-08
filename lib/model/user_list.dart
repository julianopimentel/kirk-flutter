
class Account {
  final int tenantId;
  final String nameConta;
  final int personId;

  Account({
    required this.tenantId,
    required this.nameConta,
    required this.personId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      tenantId: json['tenantId'],
      nameConta: json['name_conta'],
      personId: json['personId'],
    );
  }
}
