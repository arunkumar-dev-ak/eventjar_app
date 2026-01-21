class VisitingCardInfo {
  String? name;
  String? email;
  String? phone;
  String? rawText;

  VisitingCardInfo({this.name, this.email, this.phone, this.rawText});

  // Card has valid data only if we have at least email OR phone
  // Name alone is not enough (could be misdetected business text)
  bool get hasData => email != null || phone != null;

  // Check if we have contact info (email or phone)
  bool get hasContactInfo => email != null || phone != null;
}
