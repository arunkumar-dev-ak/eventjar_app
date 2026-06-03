import 'package:eventjar/model/meta/mobile_meta_model.dart';

class DropdownMemberResponseModel {
  final List<DropdownMemberModel> data;
  final MobileMeta? meta;

  DropdownMemberResponseModel({required this.data, this.meta});

  factory DropdownMemberResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return DropdownMemberResponseModel(
        data:
            (json['data'] as List<dynamic>?)
                ?.map(
                  (e) =>
                      DropdownMemberModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
        meta: json['meta'] != null ? MobileMeta.fromJson(json['meta']) : null,
      );
    } catch (e) {
      throw Exception('Error in DropdownMemberResponseModel.fromJson: $e');
    }
  }

  // Added toJson()
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class DropdownMemberModel {
  final String id;
  final String? userId;
  final String? friendId;
  final bool isAdmin;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? friend;

  String get memberId => id;

  DropdownMemberModel({
    required this.id,
    this.userId,
    this.friendId,
    this.isAdmin = false,
    this.user,
    this.friend,
  });

  factory DropdownMemberModel.fromJson(Map<String, dynamic> json) {
    try {
      return DropdownMemberModel(
        id: json['id']?.toString() ?? '',
        userId: json['userId']?.toString(),
        friendId: json['friendId']?.toString(),
        isAdmin: json['isAdmin'] ?? false,
        user: json['user'] as Map<String, dynamic>?,
        friend: json['friend'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw Exception('Error in DropdownMemberModel.fromJson: $e');
    }
  }

  // Added toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'isAdmin': isAdmin,
      'user': user,
      'friend': friend,
    };
  }

  String get displayName {
    try {
      // Helper function to extract name matching the User model pattern
      String extractName(Map<String, dynamic>? u) {
        if (u == null) return 'Unknown User';
        return u['name'] ?? u['username'] ?? u['email'] ?? 'Unknown User';
      }

      // 1. Direct User (e.g., Trip Creator)
      if (userId != null && user != null) {
        return extractName(user);
      }

      // 2. Connected via Friend
      if (friendId != null && friend != null) {
        // Unregistered Friend
        if (friend?['friendUserId'] == null) {
          return friend?['invitedName'] ??
              friend?['invitedEmail'] ??
              'Unknown User';
        }

        // Registered Friend (Extracting name directly without ID checks)
        final friendUser = friend?['friendUser'];
        final baseUser = friend?['user'];

        // Try friendUser first, then fallback to base user, then invited name
        if (friendUser != null) return extractName(friendUser);
        if (baseUser != null) return extractName(baseUser);

        return friend?['invitedName'] ?? 'Unknown User';
      }

      return 'Unknown User';
    } catch (e) {
      return 'Unknown User';
    }
  }
}
