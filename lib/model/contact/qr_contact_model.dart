import 'package:eventjar/model/contact/mobile_contact_model.dart';

class QrContactModel {
  final String name;
  final String email;
  final PhoneParsed? phoneParsed;

  QrContactModel({required this.name, this.phoneParsed, required this.email});

  Map<String, dynamic> toJson() {
    return {'name': name, 'phoneParsed': phoneParsed?.toJson(), 'email': email};
  }

  factory QrContactModel.fromJson(Map<String, dynamic> json) {
    return QrContactModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneParsed: json['phoneParsed'] != null
          ? PhoneParsed.fromJson(json['phoneParsed'])
          : null,
    );
  }

  @override
  String toString() {
    return 'ContactModel(name: $name, phoneParsed: ${phoneParsed.toString()}, email: $email)';
  }
}
