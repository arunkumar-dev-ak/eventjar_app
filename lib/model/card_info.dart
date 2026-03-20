import 'package:eventjar/model/contact/mobile_contact_model.dart';

class VisitingCardInfo {
  String? name;
  String? email;
  String? phone;
  PhoneParsed? phoneParsed;
  String? rawText;

  // Additional info extracted from card
  String? phone2;
  PhoneParsed? phone2Parsed;
  String? company;
  String? website;
  String? address;

  VisitingCardInfo({
    this.name,
    this.email,
    this.phone,
    this.phoneParsed,
    this.rawText,
    this.phone2,
    this.phone2Parsed,
    this.company,
    this.website,
    this.address,
  });

  // Card has valid data only if we have at least email OR phone
  // Name alone is not enough (could be misdetected business text)
  bool get hasData => email != null || phone != null;

  // Check if we have contact info (email or phone)
  bool get hasContactInfo => email != null || phone != null;

  // Whether the card has any extra info beyond name/email/phone
  bool get hasAdditionalInfo =>
      phone2 != null || company != null || website != null || address != null;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'phoneParsed': phoneParsed?.toJson(),
    'rawText': rawText,
    'phone2': phone2,
    'company': company,
    'website': website,
    'address': address,
  };
}
