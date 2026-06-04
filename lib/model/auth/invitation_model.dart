import 'package:eventjar/model/contact/mobile_contact_model.dart';

class InvitationResolveResponse {
  final bool success;
  final InvitationData data;

  InvitationResolveResponse({required this.success, required this.data});

  factory InvitationResolveResponse.fromJson(Map<String, dynamic> json) {
    return InvitationResolveResponse(
      success: json['success'],
      data: InvitationData.fromJson(json['data']),
    );
  }
}

class InvitationData {
  final String? name;
  final String? email;
  final PhoneParsed? phoneParsed;
  final String? role;
  final String? type;
  final String? inviterName;
  final String? inviterCompany;
  final String? inviterAvatar;

  InvitationData({
    this.name,
    this.email,
    this.phoneParsed,
    this.role,
    this.type,
    this.inviterName,
    this.inviterCompany,
    this.inviterAvatar,
  });

  factory InvitationData.fromJson(Map<String, dynamic> json) {
    return InvitationData(
      name: json['name'],
      email: json['email'],
      phoneParsed: json['phoneParsed'] != null
          ? PhoneParsed.fromJson(json['phoneParsed'])
          : null,
      role: json['role'],
      type: json['type'],
      inviterName: json['inviter_name'],
      inviterCompany: json['inviter_company'],
      inviterAvatar: json['inviter_avatar'],
    );
  }
}
