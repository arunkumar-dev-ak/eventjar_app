class EventAttendeeRequestResponse {
  final List<AttendeeMeetingRequest> sent;
  final List<AttendeeMeetingRequest> received;

  EventAttendeeRequestResponse({required this.sent, required this.received});

  factory EventAttendeeRequestResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EventAttendeeRequestResponse(
        sent: (json['sent'] as List)
            .map(
              (e) => AttendeeMeetingRequest.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        received: (json['received'] as List)
            .map(
              (e) => AttendeeMeetingRequest.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      throw Exception('Error parsing EventAttendeeRequestResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'sent': sent.map((e) => e.toJson()).toList(),
    'received': received.map((e) => e.toJson()).toList(),
  };
}

class AttendeeMeetingRequest {
  final String id;
  final String eventId;
  final String fromUserId;
  final String toUserId;
  final String message;
  final String status;
  final String? preferredTime;
  final int duration;
  final String? collaborationNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? contactId;
  final UserSummary fromUser;
  final UserSummary toUser;
  final EventSummary event;

  AttendeeMeetingRequest({
    required this.id,
    required this.eventId,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.status,
    this.preferredTime,
    required this.duration,
    this.collaborationNote,
    required this.createdAt,
    required this.updatedAt,
    this.contactId,
    required this.fromUser,
    required this.toUser,
    required this.event,
  });

  factory AttendeeMeetingRequest.fromJson(Map<String, dynamic> json) {
    try {
      return AttendeeMeetingRequest(
        id: json['id'],
        eventId: json['eventId'],
        fromUserId: json['fromUserId'],
        toUserId: json['toUserId'],
        message: json['message'] ?? '',
        status: json['status'] ?? '',
        preferredTime: json['preferredTime'],
        duration: json['duration'] ?? 0,
        collaborationNote: json['collaborationNote'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        contactId: json['contactId'],
        fromUser: UserSummary.fromJson(json['fromUser']),
        toUser: UserSummary.fromJson(json['toUser']),
        event: EventSummary.fromJson(json['event']),
      );
    } catch (e) {
      throw Exception('Error parsing AttendeeMeetingRequest: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'message': message,
    'status': status,
    'preferredTime': preferredTime,
    'duration': duration,
    'collaborationNote': collaborationNote,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'contactId': contactId,
    'fromUser': fromUser.toJson(),
    'toUser': toUser.toJson(),
    'event': event.toJson(),
  };
}

class UserSummary {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? company;
  final String? jobTitle;

  UserSummary({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.company,
    this.jobTitle,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    try {
      return UserSummary(
        id: json['id'],
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        avatarUrl: json['avatarUrl'],
        company: json['company'],
        jobTitle: json['jobTitle'],
      );
    } catch (e) {
      throw Exception('Error parsing UserSummary: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'company': company,
    'jobTitle': jobTitle,
  };
}

class EventSummary {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  EventSummary({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  factory EventSummary.fromJson(Map<String, dynamic> json) {
    try {
      return EventSummary(
        id: json['id'],
        title: json['title'] ?? '',
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
      );
    } catch (e) {
      throw Exception('Error parsing EventSummary: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };
}
