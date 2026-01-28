import 'package:eventjar/logger_service.dart';

class ContactMeetingResponse {
  final List<ContactMeeting> meetings;

  ContactMeetingResponse({required this.meetings});

  factory ContactMeetingResponse.fromJson(List<dynamic> json) {
    try {
      return ContactMeetingResponse(
        meetings: json
            .map((e) => ContactMeeting.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing ContactMeetingResponse: $e',
      );
      rethrow;
    }
  }

  List<Map<String, dynamic>> toJson() =>
      meetings.map((e) => e.toJson()).toList();
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

  // Relations (from include)
  final ContactMeetingContact? contact;
  final ContactOrganizer? organizer;
  final ScheduledByUser? scheduledByUser;

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
        duration: json['duration'],
        status: json['status'],
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
            ? ContactMeetingContact.fromJson(json['contact'])
            : null,
        organizer: json['organizer'] != null
            ? ContactOrganizer.fromJson(json['organizer'])
            : null,
        scheduledByUser: json['scheduledByUser'] != null
            ? ScheduledByUser.fromJson(json['scheduledByUser'])
            : null,
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing ContactMeeting: $e');
      rethrow;
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
    'contact': contact?.toJson(),
    'organizer': organizer?.toJson(),
    'scheduledByUser': scheduledByUser?.toJson(),
  };
}

class ContactMeetingContact {
  final String id;
  final String? name;
  final String? email;
  final String? company;
  final String? position;
  final String stage;

  ContactMeetingContact({
    required this.id,
    this.name,
    this.email,
    this.company,
    this.position,
    required this.stage,
  });

  factory ContactMeetingContact.fromJson(Map<String, dynamic> json) {
    try {
      return ContactMeetingContact(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        company: json['company'],
        position: json['position'],
        stage: json['stage'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Contact: $e');
      rethrow;
    }
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

class ContactOrganizer {
  final String id;
  final String? name;
  final String? email;
  final String? company;

  ContactOrganizer({required this.id, this.name, this.email, this.company});

  factory ContactOrganizer.fromJson(Map<String, dynamic> json) {
    try {
      return ContactOrganizer(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        company: json['company'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Organizer: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'company': company,
  };
}

class ScheduledByUser {
  final String id;
  final String? name;
  final String? email;

  ScheduledByUser({required this.id, this.name, this.email});

  factory ScheduledByUser.fromJson(Map<String, dynamic> json) {
    try {
      return ScheduledByUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing ScheduledByUser: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
