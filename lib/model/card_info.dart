import 'package:eventjar/model/contact/mobile_contact_model.dart';

class VisitingCardInfo {
  String? name;
  String? email;
  String? phone;
  PhoneParsed? phoneParsed;
  String? rawText;

  VisitingCardInfo({
    this.name,
    this.email,
    this.phone,
    this.phoneParsed,
    this.rawText,
  });

  // Card has valid data only if we have at least email OR phone
  // Name alone is not enough (could be misdetected business text)
  bool get hasData => email != null || phone != null;

  // Check if we have contact info (email or phone)
  bool get hasContactInfo => email != null || phone != null;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'phoneParsed': phoneParsed?.toJson(),
    'rawText': rawText,
  };
}
