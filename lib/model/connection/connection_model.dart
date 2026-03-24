import 'package:eventjar/logger_service.dart';

class ConnectionResponse {
  final SentRequests sent;
  final ReceivedRequests received;

  ConnectionResponse({required this.sent, required this.received});

  factory ConnectionResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ConnectionResponse(
        sent: SentRequests.fromJson(json['sent']),
        received: ReceivedRequests.fromJson(json['received']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing ConnectionResponse');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'sent': sent.toJson(),
    'received': received.toJson(),
  };
}

class ConnectionPaginationData<T> {
  final int count;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<T> requests;

  const ConnectionPaginationData({
    required this.count,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.requests,
  });

  factory ConnectionPaginationData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ConnectionPaginationData(
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      requests:
          (json['requests'] as List<dynamic>?)
              ?.map((e) => fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class SentRequests extends ConnectionPaginationData<ConnectionRequest> {
  SentRequests({
    required super.count,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
    required super.requests,
  });

  factory SentRequests.fromJson(Map<String, dynamic> json) {
    final base = ConnectionPaginationData.fromJson(
      json,
      ConnectionRequest.fromJson,
    );

    return SentRequests(
      count: base.count,
      total: base.total,
      page: base.page,
      limit: base.limit,
      totalPages: base.totalPages,
      requests: base.requests,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'requests': requests.map((e) => e.toJson()).toList(),
  };
}

class ReceivedRequests extends ConnectionPaginationData<ConnectionRequest> {
  ReceivedRequests({
    required super.count,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
    required super.requests,
  });

  factory ReceivedRequests.fromJson(Map<String, dynamic> json) {
    final base = ConnectionPaginationData.fromJson(
      json,
      ConnectionRequest.fromJson,
    );

    return ReceivedRequests(
      count: base.count,
      total: base.total,
      page: base.page,
      limit: base.limit,
      totalPages: base.totalPages,
      requests: base.requests,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'requests': requests.map((e) => e.toJson()).toList(),
  };
}

class ConnectionRequest {
  final String id;
  final String eventId;
  final String eventTitle;
  final DateTime eventStartDate;
  final String fromUserId;
  final String fromUserName;
  final String fromUserUsername;
  final String fromUserEmail;
  final String? fromUserAvatar;
  final String? fromUserPosition;
  final String? fromUserCompany;
  final String? fromUserBio;
  final List<UserBadge> fromUserBadges;
  final int fromUserTotalBadges;
  final String toUserId;
  final String toUserName;
  final String toUserUsername;
  final String toUserEmail;
  final String? toUserAvatar;
  final String? toUserPosition;
  final String? toUserCompany;
  final String? toUserBio;
  final List<UserBadge> toUserBadges;
  final int toUserTotalBadges;
  final String message;
  final String status;
  final String preferredTime;
  final int duration;
  final String collaborationNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConnectionRequest({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.eventStartDate,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserUsername,
    required this.fromUserEmail,
    this.fromUserAvatar,
    this.fromUserPosition,
    this.fromUserCompany,
    this.fromUserBio,
    required this.fromUserBadges,
    required this.fromUserTotalBadges,
    required this.toUserId,
    required this.toUserName,
    required this.toUserUsername,
    required this.toUserEmail,
    this.toUserAvatar,
    this.toUserPosition,
    this.toUserCompany,
    this.toUserBio,
    required this.toUserBadges,
    required this.toUserTotalBadges,
    required this.message,
    required this.status,
    required this.preferredTime,
    required this.duration,
    required this.collaborationNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      eventTitle: json['eventTitle'] ?? '',
      eventStartDate: _parseDate(json['eventStartDate']),
      fromUserId: json['fromUserId'] ?? '',
      fromUserName: json['fromUserName'] ?? '',
      fromUserUsername: json['fromUserUsername'] ?? '',
      fromUserEmail: json['fromUserEmail'] ?? '',
      fromUserAvatar: json['fromUserAvatar'],
      fromUserPosition: json['fromUserPosition'],
      fromUserCompany: json['fromUserCompany'],
      fromUserBio: json['fromUserBio'],
      fromUserBadges:
          (json['fromUserBadges'] as List<dynamic>?)
              ?.map((e) => UserBadge.fromJson(e))
              .toList() ??
          const [],
      fromUserTotalBadges: json['fromUserTotalBadges'] ?? 0,
      toUserId: json['toUserId'] ?? '',
      toUserName: json['toUserName'] ?? '',
      toUserUsername: json['toUserUsername'] ?? '',
      toUserEmail: json['toUserEmail'] ?? '',
      toUserAvatar: json['toUserAvatar'],
      toUserPosition: json['toUserPosition'],
      toUserCompany: json['toUserCompany'],
      toUserBio: json['toUserBio'],
      toUserBadges:
          (json['toUserBadges'] as List<dynamic>?)
              ?.map((e) => UserBadge.fromJson(e))
              .toList() ??
          const [],
      toUserTotalBadges: json['toUserTotalBadges'] ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      preferredTime: json['preferredTime'] ?? '',
      duration: json['duration'] ?? 0,
      collaborationNote: json['collaborationNote'] ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'eventTitle': eventTitle,
    'eventStartDate': eventStartDate.toIso8601String(),
    'fromUserId': fromUserId,
    'fromUserName': fromUserName,
    'fromUserUsername': fromUserUsername,
    'fromUserEmail': fromUserEmail,
    'fromUserAvatar': fromUserAvatar,
    'fromUserPosition': fromUserPosition,
    'fromUserCompany': fromUserCompany,
    'fromUserBio': fromUserBio,
    'fromUserBadges': fromUserBadges.map((e) => e.toJson()).toList(),
    'fromUserTotalBadges': fromUserTotalBadges,
    'toUserId': toUserId,
    'toUserName': toUserName,
    'toUserUsername': toUserUsername,
    'toUserEmail': toUserEmail,
    'toUserAvatar': toUserAvatar,
    'toUserPosition': toUserPosition,
    'toUserCompany': toUserCompany,
    'toUserBio': toUserBio,
    'toUserBadges': toUserBadges.map((e) => e.toJson()).toList(),
    'toUserTotalBadges': toUserTotalBadges,
    'message': message,
    'status': status,
    'preferredTime': preferredTime,
    'duration': duration,
    'collaborationNote': collaborationNote,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class UserBadge {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserBadge({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

DateTime _parseDate(dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.parse(value);
}
