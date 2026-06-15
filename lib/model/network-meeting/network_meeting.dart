import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting.dart';

class NetworkMeetingResponse {
  final List<NetworkMeeting> data;
  final NetworkMeetingPaging paging;

  NetworkMeetingResponse({required this.data, required this.paging});

  factory NetworkMeetingResponse.fromJson(Map<String, dynamic> json) {
    try {
      return NetworkMeetingResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => NetworkMeeting.fromJson(e as Map<String, dynamic>))
            .toList(),
        paging: NetworkMeetingPaging.fromJson(
          json['paging'] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing NetworkMeetingResponse: $e',
      );
      rethrow;
    }
  }
}

class NetworkMeeting {
  final String id;
  final String contactId;
  final String scheduledByUserId;
  final DateTime scheduledAt;
  final String? meetingTime;
  final int duration;
  final String? method;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? googleEventId;
  final String? googleMeetLink;
  final NetworkMeetingContact? contact;
  final NetworkMeetingScheduledByUser? scheduledByUser;

  NetworkMeeting({
    required this.id,
    required this.contactId,
    required this.scheduledByUserId,
    required this.scheduledAt,
    this.meetingTime,
    required this.duration,
    this.method,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.googleEventId,
    this.googleMeetLink,
    this.contact,
    this.scheduledByUser,
  });

  factory NetworkMeeting.fromJson(Map<String, dynamic> json) {
    try {
      return NetworkMeeting(
        id: json['id'],
        contactId: json['contactId'],
        scheduledByUserId: json['scheduledByUserId'],
        scheduledAt: DateTime.parse(json['scheduledAt']),
        meetingTime: json['meetingTime'],
        duration: json['duration'],
        method: json['method'],
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
        googleEventId: json['googleEventId'],
        googleMeetLink: json['googleMeetLink'],
        contact: json['contact'] != null
            ? NetworkMeetingContact.fromJson(json['contact'])
            : null,
        scheduledByUser: json['scheduledByUser'] != null
            ? NetworkMeetingScheduledByUser.fromJson(json['scheduledByUser'])
            : null,
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing NetworkMeeting: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contactId': contactId,
    'scheduledByUserId': scheduledByUserId,
    'scheduledAt': scheduledAt.toIso8601String(),
    'meetingTime': meetingTime,
    'duration': duration,
    'method': method,
    'status': status,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
    'googleEventId': googleEventId,
    'googleMeetLink': googleMeetLink,
    'contact': contact?.toJson(),
    'scheduledByUser': scheduledByUser?.toJson(),
  };

  ContactMeeting toContactMeeting() {
    return ContactMeeting(
      id: id,
      contactId: contactId,
      scheduledByUserId: scheduledByUserId,
      scheduledAt: scheduledAt,
      duration: duration,
      status: status,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
      contact: contact != null
          ? ContactMeetingContact(
              id: contact!.id,
              name: contact!.name,
              email: contact!.email,
              company: contact!.company,
              position: contact!.position,
              stage: contact!.stage ?? 'new',
            )
          : null,
      scheduledByUser: scheduledByUser != null
          ? ScheduledByUser(
              id: scheduledByUser!.id,
              name: scheduledByUser!.name,
              email: scheduledByUser!.email,
            )
          : null,
    );
  }
}

class NetworkMeetingContact {
  final String id;
  final String? name;
  final String? email;
  final String? company;
  final String? position;
  final String? status;
  final String? stage;
  final Map<String, dynamic>? user1;
  final Map<String, dynamic>? user2;

  NetworkMeetingContact({
    required this.id,
    this.name,
    this.email,
    this.company,
    this.position,
    this.status,
    this.stage,
    this.user1,
    this.user2,
  });

  factory NetworkMeetingContact.fromJson(Map<String, dynamic> json) {
    try {
      return NetworkMeetingContact(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        company: json['company'],
        position: json['position'],
        status: json['status'],
        stage: json['stage'],
        user1: json['user1'] != null
            ? Map<String, dynamic>.from(json['user1'])
            : null,
        user2: json['user2'] != null
            ? Map<String, dynamic>.from(json['user2'])
            : null,
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing NetworkMeetingContact: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'company': company,
    'position': position,
    'status': status,
    'stage': stage,
    'user1': user1,
    'user2': user2,
  };
}

class NetworkMeetingScheduledByUser {
  final String id;
  final String? name;
  final String? email;
  final String? company;
  final String? avatarUrl;
  final String? jobTitle;

  NetworkMeetingScheduledByUser({
    required this.id,
    this.name,
    this.email,
    this.company,
    this.avatarUrl,
    this.jobTitle,
  });

  factory NetworkMeetingScheduledByUser.fromJson(Map<String, dynamic> json) {
    try {
      return NetworkMeetingScheduledByUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        company: json['company'],
        avatarUrl: json['avatarUrl'],
        jobTitle: json['jobTitle'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e(
        'Error parsing NetworkMeetingScheduledByUser: $e',
      );
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'company': company,
    'avatarUrl': avatarUrl,
    'jobTitle': jobTitle,
  };
}

class NetworkMeetingPaging {
  final NetworkMeetingCursors cursors;
  final NetworkMeetingLinks links;
  final bool hasNextPage;

  NetworkMeetingPaging({
    required this.cursors,
    required this.links,
    required this.hasNextPage,
  });

  factory NetworkMeetingPaging.fromJson(Map<String, dynamic> json) {
    return NetworkMeetingPaging(
      cursors: NetworkMeetingCursors.fromJson(
        json['cursors'] as Map<String, dynamic>,
      ),
      links: NetworkMeetingLinks.fromJson(
        json['links'] as Map<String, dynamic>,
      ),
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}

class NetworkMeetingCursors {
  final String? next;

  NetworkMeetingCursors({this.next});

  factory NetworkMeetingCursors.fromJson(Map<String, dynamic> json) {
    return NetworkMeetingCursors(next: json['next']);
  }
}

class NetworkMeetingLinks {
  final String? next;

  NetworkMeetingLinks({this.next});

  factory NetworkMeetingLinks.fromJson(Map<String, dynamic> json) {
    return NetworkMeetingLinks(next: json['next']);
  }
}
