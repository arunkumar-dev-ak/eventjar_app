class NetworkMeetingsListResponse {
  final List<NetworkMeetingResponseModel> meetings;

  NetworkMeetingsListResponse({required this.meetings});

  factory NetworkMeetingsListResponse.fromJson(List<dynamic> jsonArray) {
    return NetworkMeetingsListResponse(
      meetings: jsonArray
          .map((json) => NetworkMeetingResponseModel.fromJson(json))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'meetings': meetings.map((m) => m.toJson()).toList(),
  };
}

class NetworkMeetingResponseModel {
  final String id;
  final String contactId;
  final String scheduledByUserId;
  final DateTime scheduledAt;
  final String meetingTime;
  final int duration;
  final String? method;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  // Nested Models
  final ContactSummaryModel? contact;
  final UserSummaryModel? scheduledByUser;

  NetworkMeetingResponseModel({
    required this.id,
    required this.contactId,
    required this.scheduledByUserId,
    required this.scheduledAt,
    required this.meetingTime,
    required this.duration,
    this.method,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.contact,
    this.scheduledByUser,
  });

  factory NetworkMeetingResponseModel.fromJson(Map<String, dynamic> json) {
    return NetworkMeetingResponseModel(
      id: json['id'] ?? '',
      contactId: json['contactId'] ?? '',
      scheduledByUserId: json['scheduledByUserId'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt'] ?? ''),
      meetingTime: json['meetingTime'] ?? '',
      duration: json['duration'] ?? 60,
      method: json['method'],
      status: json['status'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      contact: json['contact'] != null
          ? ContactSummaryModel.fromJson(json['contact'])
          : null,
      scheduledByUser: json['scheduledByUser'] != null
          ? UserSummaryModel.fromJson(json['scheduledByUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'contact': contact?.toJson(),
      'scheduledByUser': scheduledByUser?.toJson(),
    };
  }
}

// Nested Contact Model
class ContactSummaryModel {
  final String id;
  final String name;
  final String? email;
  final String? company;
  final String? position;
  final String stage;

  ContactSummaryModel({
    required this.id,
    required this.name,
    this.email,
    this.company,
    this.position,
    required this.stage,
  });

  factory ContactSummaryModel.fromJson(Map<String, dynamic> json) {
    return ContactSummaryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      company: json['company'],
      position: json['position'],
      stage: json['stage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'company': company,
      'position': position,
      'stage': stage,
    };
  }
}

// Nested User Model
class UserSummaryModel {
  final String id;
  final String name;
  final String? email;

  UserSummaryModel({required this.id, required this.name, this.email});

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
