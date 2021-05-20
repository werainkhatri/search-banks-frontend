class BankModel {
  final int id;
  final String name;

  const BankModel(this.id, this.name);

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      json['id']! as int,
      json['name']! as String,
    );
  }
}
