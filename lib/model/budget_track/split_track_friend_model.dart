class SplitTrackFriendResponse {
  final List<SplitTrackFriend> data;
  final SplitTrackPagination pagination;

  SplitTrackFriendResponse({required this.data, required this.pagination});

  factory SplitTrackFriendResponse.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriendResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => SplitTrackFriend.fromJson(e))
            .toList(),
        pagination: SplitTrackPagination.fromJson(json['pagination']),
      );
    } catch (e) {
      throw Exception('Error in SplitTrackFriendResponse.fromJson: $e');
    }
  }
}

class SplitTrackFriend {
  final String id;
  final String userId;
  final String? friendUserId;
  final SplitTrackFriendUser? friendUser;
  final String invitedEmail;
  final String? invitedPhone;
  final String invitedName;
  final String source;
  final String status;
  final DateTime invitedAt;
  final bool isRegistered;

  SplitTrackFriend({
    required this.id,
    required this.userId,
    this.friendUserId,
    this.friendUser,
    required this.invitedEmail,
    this.invitedPhone,
    required this.invitedName,
    required this.source,
    required this.status,
    required this.invitedAt,
    required this.isRegistered,
  });

  String get name => friendUser?.name ?? invitedName;

  factory SplitTrackFriend.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriend(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        friendUserId: json['friendUserId'],
        friendUser: json['friendUser'] != null
            ? SplitTrackFriendUser.fromJson(json['friendUser'])
            : null,
        invitedEmail: json['invitedEmail'] ?? '',
        invitedPhone: json['invitedPhone'],
        invitedName: json['invitedName'] ?? '',
        source: json['source'] ?? '',
        status: json['status'] ?? '',
        invitedAt: DateTime.parse(json['invitedAt']),
        isRegistered: json['isRegistered'] ?? false,
      );
    } catch (e) {
      throw Exception('Error in SplitTrackFriend.fromJson: $e');
    }
  }
}

class SplitTrackFriendUser {
  final String id;
  final String name;
  final String? email;

  SplitTrackFriendUser({
    required this.id,
    required this.name,
    this.email,
  });

  factory SplitTrackFriendUser.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriendUser(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'],
      );
    } catch (e) {
      throw Exception('Error in SplitTrackFriendUser.fromJson: $e');
    }
  }
}

class SplitTrackPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  SplitTrackPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasNext => page < totalPages;

  factory SplitTrackPagination.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackPagination(
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 20,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      throw Exception('Error in SplitTrackPagination.fromJson: $e');
    }
  }
}
