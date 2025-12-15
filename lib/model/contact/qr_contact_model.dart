class QrContactModel {
  final String name;
  final String number;
  final String email;

  QrContactModel({
    required this.name,
    required this.number,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'number': number, 'email': email};
  }

  factory QrContactModel.fromJson(Map<String, dynamic> json) {
    return QrContactModel(
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ContactModel(name: $name, number: $number, email: $email)';
  }
}
