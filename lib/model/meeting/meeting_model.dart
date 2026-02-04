import 'package:eventjar/model/meta/meta_model.dart';

class ContactMeetingResponse {
  final List<ContactMeeting> data;
  final Meta? meta;

  ContactMeetingResponse({required this.data, this.meta});

  factory ContactMeetingResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ContactMeetingResponse(
        data: (json['data'] as List)
            .map((e) => ContactMeeting.fromJson(e))
            .toList(),
        meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in ContactMeetingResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    if (meta != null) 'meta': meta!.toJson(),
  };
}

class ContactMeeting {
  final String id;
  final String contactId;
  final String? organizerId;
  final String? scheduledByUserId;
  final DateTime scheduledAt;
  final int duration;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? declineReason;

  // Nested objects (optional)
  final Contact? contact;
  final UserInfo? organizer;
  final UserInfo? scheduledByUser;

  ContactMeeting({
    required this.id,
    required this.contactId,
    this.organizerId,
    this.scheduledByUserId,
    required this.scheduledAt,
    required this.duration,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.declineReason,
    this.contact,
    this.organizer,
    this.scheduledByUser,
  });

  factory ContactMeeting.fromJson(Map<String, dynamic> json) {
    try {
      return ContactMeeting(
        id: json['id'],
        contactId: json['contactId'],
        organizerId: json['organizerId'],
        scheduledByUserId: json['scheduledByUserId'],
        scheduledAt: DateTime.parse(json['scheduledAt']),
        duration: json['duration'] ?? 0,
        status: json['status'] ?? '',
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        cancelledAt: json['cancelledAt'] != null
            ? DateTime.parse(json['cancelledAt'])
            : null,
        declineReason: json['declineReason'],
        contact: json['contact'] != null
            ? Contact.fromJson(json['contact'])
            : null,
        organizer: json['organizer'] != null
            ? UserInfo.fromJson(json['organizer'])
            : null,
        scheduledByUser: json['scheduledByUser'] != null
            ? UserInfo.fromJson(json['scheduledByUser'])
            : null,
      );
    } catch (e) {
      throw Exception('Error in ContactMeeting: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contactId': contactId,
    'organizerId': organizerId,
    'scheduledByUserId': scheduledByUserId,
    'scheduledAt': scheduledAt.toIso8601String(),
    'duration': duration,
    'status': status,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
    'declineReason': declineReason,
    if (contact != null) 'contact': contact!.toJson(),
    if (organizer != null) 'organizer': organizer!.toJson(),
    if (scheduledByUser != null) 'scheduledByUser': scheduledByUser!.toJson(),
  };
}

class Contact {
  final String id;
  final String? name;
  final String? email;
  final String? company;
  final String? position;
  final String stage;

  Contact({
    required this.id,
    this.name,
    this.email,
    this.company,
    this.position,
    required this.stage,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      company: json['company'],
      position: json['position'],
      stage: json['stage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'company': company,
    'position': position,
    'stage': stage,
  };
}

class UserInfo {
  final String id;
  final String? name;
  final String? email;
  final String? company;

  UserInfo({required this.id, this.name, this.email, this.company});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'company': company,
  };
}
