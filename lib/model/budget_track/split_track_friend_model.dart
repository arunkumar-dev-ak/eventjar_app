class SplitTrackFriendResponse {
  final List<SplitTrackFriend> data;
  final SplitTrackPaging paging;

  SplitTrackFriendResponse({required this.data, required this.paging});

  factory SplitTrackFriendResponse.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriendResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => SplitTrackFriend.fromJson(e))
            .toList(),
        paging: SplitTrackPaging.fromJson(json['paging']),
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
  final SplitTrackFriendUser? user;
  final SplitTrackFriendUser? friendUser;
  final String invitedEmail;
  final String? invitedPhone;
  final String invitedName;
  final String source;
  final String status;
  final DateTime createdAt;

  SplitTrackFriend({
    required this.id,
    required this.userId,
    this.friendUserId,
    this.user,
    this.friendUser,
    required this.invitedEmail,
    this.invitedPhone,
    required this.invitedName,
    required this.source,
    required this.status,
    required this.createdAt,
  });

  String get name => friendUser?.name ?? invitedName;

  bool get isRegistered => friendUserId != null;

  factory SplitTrackFriend.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriend(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        friendUserId: json['friendUserId'],
        user: json['user'] != null
            ? SplitTrackFriendUser.fromJson(json['user'])
            : null,
        friendUser: json['friendUser'] != null
            ? SplitTrackFriendUser.fromJson(json['friendUser'])
            : null,
        invitedEmail: json['invitedEmail'] ?? '',
        invitedPhone: json['invitedPhone'],
        invitedName: json['invitedName'] ?? '',
        source: json['source'] ?? '',
        status: json['status'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
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
  final String? avatarUrl;

  SplitTrackFriendUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  factory SplitTrackFriendUser.fromJson(Map<String, dynamic> json) {
    try {
      return SplitTrackFriendUser(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'],
        avatarUrl: json['avatarUrl'],
      );
    } catch (e) {
      throw Exception('Error in SplitTrackFriendUser.fromJson: $e');
    }
  }
}

class SplitTrackPaging {
  final String? nextCursor;
  final String? nextLink;
  final bool hasNextPage;

  SplitTrackPaging({this.nextCursor, this.nextLink, required this.hasNextPage});

  factory SplitTrackPaging.fromJson(Map<String, dynamic> json) {
    try {
      final cursors = json['cursors'] as Map<String, dynamic>?;
      final links = json['links'] as Map<String, dynamic>?;

      return SplitTrackPaging(
        nextCursor: cursors?['next'],
        nextLink: links?['next'],
        hasNextPage: json['hasNextPage'] ?? false,
      );
    } catch (e) {
      throw Exception('Error in SplitTrackPaging.fromJson: $e');
    }
  }
}
