import 'package:eventjar/logger_service.dart';

class ContactResponse {
  final List<Contact> contacts;

  ContactResponse({required this.contacts});

  // Use this for a List at the root level
  factory ContactResponse.fromList(List<dynamic> list) {
    try {
      return ContactResponse(
        contacts: list
            .map((e) => Contact.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error parsing ContactResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'contacts': contacts.map((e) => e.toJson()).toList(),
  };
}

class Contact {
  final String id;
  final String? organizerId;
  final String name;
  final String? username;
  final String email;
  final String? phone;
  final String? company;
  final String? position;
  final String? industry;
  final ContactStage stage;
  final String? nextAction;
  final List<String> tags;
  // final Map<String, String> customAttributes;
  final String? notes;
  final DateTime createdAt;
  // final String
  // updatedAt; // string per your example, could make DateTime if preferred
  final DateTime? lastMeetingDate;
  final DateTime? nextFollowUpDate;
  final DateTime? stageEnteredAt;
  final DateTime? stageCompletedAt;
  final DateTime? stageLockedAt;
  final ContactStage? previousStage;
  final bool isOverdue;
  final DateTime? overdueSince;
  final String? overdueDuration;
  final bool isDueSoon;
  final bool meetingScheduled;
  final bool meetingConfirmed;
  final bool meetingCompleted;
  final bool messageScheduled;
  final bool messageSent;
  final bool messageReplied;
  final bool? hasAnySentMessage;
  final bool? isEventJarUser;

  Contact({
    required this.id,
    this.organizerId,
    required this.name,
    this.username,
    required this.email,
    this.phone,
    this.company,
    this.position,
    this.industry,
    required this.stage,
    this.nextAction,
    required this.tags,
    // required this.customAttributes,
    this.notes,
    required this.createdAt,
    // required this.updatedAt,
    this.lastMeetingDate,
    this.nextFollowUpDate,
    this.stageEnteredAt,
    this.stageCompletedAt,
    this.stageLockedAt,
    this.previousStage,
    required this.isOverdue,
    this.overdueSince,
    this.overdueDuration,
    required this.isDueSoon,
    required this.meetingScheduled,
    required this.meetingConfirmed,
    required this.meetingCompleted,
    required this.messageScheduled,
    required this.messageSent,
    required this.messageReplied,
    required this.hasAnySentMessage,
    this.isEventJarUser,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    try {
      return Contact(
        id: json['id'],
        organizerId: json['organizerId'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        company: json['company'],
        position: json['position'],
        industry: json['industry'],
        stage: contactStageFromString(json['stage']),
        nextAction: json['nextAction'],
        tags: List<String>.from(json['tags']),
        // customAttributes: Map<String, String>.from(
        //   json['customAttributes'] ?? {},
        // ),
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        // updatedAt: json['updatedAt'],
        lastMeetingDate: json['lastMeetingDate'] == null
            ? null
            : DateTime.parse(json['lastMeetingDate']),
        nextFollowUpDate: json['nextFollowUpDate'] == null
            ? null
            : DateTime.parse(json['nextFollowUpDate']),
        stageEnteredAt: json['stageEnteredAt'] == null
            ? null
            : DateTime.parse(json['stageEnteredAt']),
        stageCompletedAt: json['stageCompletedAt'] == null
            ? null
            : DateTime.tryParse(json['stageCompletedAt']),
        stageLockedAt: json['stageLockedAt'] == null
            ? null
            : DateTime.tryParse(json['stageLockedAt']),
        previousStage: json['previousStage'] != null
            ? contactStageFromString(json['previousStage'])
            : null,
        isOverdue: json['isOverdue'],
        overdueSince: json['overdueSince'] == null
            ? null
            : DateTime.tryParse(json['overdueSince']),
        overdueDuration: json['overdueDuration'],
        isDueSoon: json['isDueSoon'],
        meetingScheduled: json['meetingScheduled'],
        meetingConfirmed: json['meetingConfirmed'],
        meetingCompleted: json['meetingCompleted'],
        messageScheduled: json['messageScheduled'],
        messageSent: json['messageSent'],
        messageReplied: json['messageReplied'],
        hasAnySentMessage: json['hasAnySentMessage'] ?? false,
        isEventJarUser: json['isEventJarUser'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      throw Exception('Error parsing Contact: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizerId': organizerId,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'company': company,
    'position': position,
    'industry': industry,
    'stage': stage.toShortString(),
    'nextAction': nextAction,
    'tags': tags,
    // 'customAttributes': customAttributes,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    // 'updatedAt': updatedAt,
    'lastMeetingDate': lastMeetingDate?.toIso8601String(),
    'nextFollowUpDate': nextFollowUpDate?.toIso8601String(),
    'stageEnteredAt': stageEnteredAt?.toIso8601String(),
    'stageCompletedAt': stageCompletedAt?.toIso8601String(),
    'stageLockedAt': stageLockedAt?.toIso8601String(),
    'previousStage': previousStage?.toShortString(),
    'isOverdue': isOverdue,
    'overdueSince': overdueSince?.toIso8601String(),
    'overdueDuration': overdueDuration,
    'isDueSoon': isDueSoon,
    'meetingScheduled': meetingScheduled,
    'meetingConfirmed': meetingConfirmed,
    'meetingCompleted': meetingCompleted,
    'messageScheduled': messageScheduled,
    'messageSent': messageSent,
    'messageReplied': messageReplied,
    'hasAnySentMessage': hasAnySentMessage,
    'isEventJarUser': isEventJarUser,
  };
}

enum ContactStage {
  newContact,
  followup24h,
  followup7d,
  followup30d,
  qualified,
}

ContactStage contactStageFromString(String? str) {
  switch (str) {
    case 'new':
    case 'newContact':
      return ContactStage.newContact;
    case 'followup_24h':
    case 'followup24h':
      return ContactStage.followup24h;
    case 'followup_7d':
    case 'followup7d':
      return ContactStage.followup7d;
    case 'followup_30d':
    case 'followup30d':
      return ContactStage.followup30d;
    case 'qualified':
      return ContactStage.qualified;
    default:
      return ContactStage.newContact;
  }
}

extension ContactStageExtension on ContactStage {
  String toShortString() {
    switch (this) {
      case ContactStage.newContact:
        return 'new';
      case ContactStage.followup24h:
        return 'followup_24h';
      case ContactStage.followup7d:
        return 'followup_7d';
      case ContactStage.followup30d:
        return 'followup_30d';
      case ContactStage.qualified:
        return 'qualified';
    }
  }
}
